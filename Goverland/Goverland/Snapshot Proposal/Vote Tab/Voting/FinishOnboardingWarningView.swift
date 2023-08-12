//
//  FinishOnboardingWarningView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 12.08.23.
//

import SwiftUI

struct FinishOnboardingWarningView: View {
    @Environment(\.presentationMode) private var presentationMode
    var onContinueOnboarding: () -> Void

    var body: some View {
        VStack() {
            HStack {
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.gray)
                        .frame(width: 30, height: 30)
                }
            }

            VStack(alignment: .center) {
                Text("Don't hurry up!")
            }
            .font(.title3Semibold)
            .foregroundColor(.textWhite)

            Spacer()

            Text("Please finish onboarding to get into the full functionality of the application!")
                .font(.bodyRegular)
                .foregroundColor(.textWhite)
                .padding(.bottom)

            PrimaryButton("Continue Onboarding") {
                Tracker.track(.snpDetailsContinueOnboarding)
                presentationMode.wrappedValue.dismiss()
                onContinueOnboarding()
            }
        }
        .padding()
        .background(alignment: .top) {
            Image("proposal-vote-popup-background")
                .resizable()
                .scaledToFit()
        }
    }
}
