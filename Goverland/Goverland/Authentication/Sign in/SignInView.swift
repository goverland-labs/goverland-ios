//
//  SignInView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-11.
//

import SwiftUI

struct SignInView: View {
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
            .onAppear() { Tracker.track(.screenOnbaordingSignIn) }
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
        .padding(.top, getPadding())
    }
}

fileprivate func getPadding() -> CGFloat {
    if UIDevice.current.userInterfaceIdiom == .phone && UIScreen.screenHeight <= 667.0 {
        // iPhone SE or smaller
        return 30
    } else {
        return 50
    }
}

fileprivate struct SignInOnboardingFooterControlsView: View {
    @State private var showSignIn = false
    @StateObject var dataSource = SignInDataSource()

    var body: some View {
        VStack(spacing: 20) {
            PrimaryButton("Sign in with wallet") {
                Tracker.track(.onboardingSignInWithWallet)
                showSignIn = true
            }

            Button("Continue as a guest") {
                Tracker.track(.onboardingSignInAsGuest)
                dataSource.guestAuth()
            }
            .disabled(dataSource.loading)
            .fontWeight(.semibold)
            .padding(.bottom)
            .accentColor(.secondaryContainer)
        }
        .sheet(isPresented: $showSignIn) {
            TwoStepsModalView()
                .presentationDetents([.medium, .large])
        }
    }
}
