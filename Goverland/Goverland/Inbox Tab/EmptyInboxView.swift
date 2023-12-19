//
//  EmptyInboxView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 11.07.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct EmptyInboxView: View {
    var body: some View {
        // TODO: change once we have subscriptions_count in Profile from backend
        if true {
            _WelcomeView()
        } else {
            _EmptyInboxView()
        }
    }
}

fileprivate struct _WelcomeView: View {
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Now, you will see new proposals here!")
                .multilineTextAlignment(.center)
                .font(.title3Semibold)
                .foregroundColor(.textWhite)
                .padding(.horizontal, 16)

            Image("welcome-illustration-inbox")
                .resizable()
                .aspectRatio(contentMode: .fit)

            Text("You're not following any DAO yet. Follow DAOs so you don't miss the updates!")
                .multilineTextAlignment(.center)
                .font(.calloutRegular)
                .foregroundColor(.textWhite)
                .padding(.horizontal, 16)

            Spacer()

            PrimaryButton("Discover DAOs") {
                activeSheetManager.activeSheet = .followDaos
            }
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 16)
        .onAppear {
            // TODO: track
        }
    }
}

fileprivate struct _EmptyInboxView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Spacer()
            VStack(spacing: 20) {
                HStack {
                    Text("Your inbox is empty")
                    Image(systemName: "envelope.open.fill")
                }
                .font(.titleSemibold)
                .foregroundColor(.textWhite)

                Text("Follow new DAOs to receive updates!")
                    .font(.body)
                    .foregroundColor(.textWhite)

            }
            Spacer()
            PrimaryButton("My followed DAOs") {
                TabManager.shared.selectedTab = .profile
                TabManager.shared.profilePath = [.subscriptions]
            }
            Spacer()
        }
        .padding([.horizontal, .bottom], 16)
        .onAppear {
            Tracker.track(.screenInboxEmpty)
        }
    }
}
