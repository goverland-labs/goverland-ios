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
            .onAppear() { Tracker.track(.screenSignIn) }
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
        Image("onboarding-sign-in")
    }
}

fileprivate struct SignInOnboardingHeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: -15) {
                    Text("Sign in")
                        .foregroundColor(.textWhite)
                    Text("with wallet")
                        .foregroundColor(.primaryDim)
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

                .accentColor(.secondaryContainer)

                HStack {
                    if dataSource.loading {
                        ProgressView()
                            .foregroundColor(.textWhite20)
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
                .presentationDetents([.height(500)])
        }
    }
}
