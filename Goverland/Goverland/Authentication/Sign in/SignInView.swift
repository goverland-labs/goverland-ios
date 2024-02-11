//
//  SignInView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-11.
//

import SwiftUI

struct SignInView: View {
    @Environment(\.isPresented) private var isPresented
    @Environment(\.dismiss) private var dismiss
    @Setting(\.authToken) private var authToken

    let source: Source

    enum Source: String {
        case popover
        case inbox
        case profile
    }

    var body: some View {
        ZStack {
            SignInOnboardingBackgroundView()

            VStack {
                SignInOnboardingHeaderView()
                Spacer()
                SignInOnboardingFooterControlsView()
            }
            .navigationBarBackButtonHidden(true)
            .padding(.horizontal)
            .onAppear() {
                Tracker.track(.screenSignIn, parameters: ["source" : source.rawValue])
            }
        }
        .onChange(of: authToken) { _, token in
            if !token.isEmpty && isPresented {
                dismiss()
            }
        }
    }
}

fileprivate struct SignInOnboardingBackgroundView: View {
    var body: some View {
        Image("sign-in")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

fileprivate struct SignInOnboardingHeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: -15) {
                    Text("Sign in")
                        .foregroundStyle(Color.textWhite)
                    Text("with wallet")
                        .foregroundStyle(Color.primaryDim)
                }
                .font(.chillaxMedium(size: 46))
                .kerning(-2.5)

                Spacer()
            }
        }
    }
}

fileprivate struct SignInOnboardingFooterControlsView: View {
    @State private var showSignIn = false
    @StateObject var dataSource = SignInDataSource()

    var body: some View {
        VStack(spacing: 20) {
            PrimaryButton("Sign in with wallet") {
                Haptic.medium()
                Tracker.track(.signInWithWallet)
                showSignIn = true
            }

            HStack(spacing: 8) {
                Spacer() // spacer to balance out loading indicator
                    .frame(width: 30)

                Button("Continue as a guest") {
                    Tracker.track(.signInAsGuest)
                    dataSource.guestAuth()
                }
                .disabled(dataSource.loading)
                .fontWeight(.semibold)
                .tint(.secondaryContainer)

                HStack {
                    if dataSource.loading {
                        ProgressView()
                            .foregroundStyle(Color.textWhite20)
                            .controlSize(.mini)
                    }
                    Spacer()
                }
                .frame(width: 30)

            }
            .padding(.bottom)
        }
        .sheet(isPresented: $showSignIn) {
            SignInTwoStepsView()
                .presentationDetents([.height(500), .large])
        }
    }
}
