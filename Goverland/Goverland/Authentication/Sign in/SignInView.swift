//
//  SignInView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-11.
//

import SwiftUI

struct SignInView: View {
    let source: Source

    @Setting(\.authToken) private var authToken

    @Environment(\.isPresented) private var isPresented
    @Environment(\.dismiss) private var dismiss

    enum Source: String {
        case popover
        case inbox
        case profile
    }

    var body: some View {
        ZStack {
            _SignInOnboardingBackgroundView()

            VStack {
                _SignInHeaderView()
                Spacer()
                _SignInFooterControlsView()
            }
            .navigationBarBackButtonHidden(true)
            .padding(.horizontal)
            .onAppear() {
                Tracker.track(.screenSignIn, parameters: ["source" : source.rawValue])
            }
            .onChange(of: authToken) { _, authToken in
                guard !authToken.isEmpty else { return }
                if isPresented {
                    dismiss()
                }
            }
        }
    }
}

fileprivate struct _SignInOnboardingBackgroundView: View {
    var body: some View {
        Image("sign-in")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

fileprivate struct _SignInHeaderView: View {
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

fileprivate struct _SignInFooterControlsView: View {
    @State private var showSignIn = false
    @StateObject private var dataSource = SignInDataSource()

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
            SignInTwoStepsView { /* do nothing on sign in */ }
            .presentationDetents([.height(500), .large])
        }
    }
}
