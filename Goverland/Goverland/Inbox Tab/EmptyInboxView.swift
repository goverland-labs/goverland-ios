//
//  EmptyInboxView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 11.07.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import SwiftData

struct EmptyInboxView: View {
    @Query private var profiles: [UserProfile]

    var newUser: Bool {
        guard let selected = profiles.first(where: { $0.selected }) else { return false }
        return selected.subscriptionsCount == 0
    }

    var body: some View {
        if newUser {
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
                .foregroundStyle(Color.textWhite)
                .padding(.horizontal, Constants.horizontalPadding)

            Image("welcome-illustration-inbox")
                .resizable()
                .aspectRatio(contentMode: .fit)

            Text("You're not following any DAO yet. Follow DAOs so you don't miss the updates!")
                .multilineTextAlignment(.center)
                .font(.calloutRegular)
                .foregroundStyle(Color.textWhite)
                .padding(.horizontal, Constants.horizontalPadding)

            Spacer()

            PrimaryButton("Discover DAOs") {
                activeSheetManager.activeSheet = .followDaos
            }
            .padding(.horizontal, Constants.horizontalPadding)
        }
        .padding(.bottom, 16)
        .onAppear {
            Tracker.track(.screenInboxWelcome)
        }
    }
}

fileprivate struct _EmptyInboxView: View {
    @EnvironmentObject private var pathManager: NavigationPathManager
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Text("Your inbox is empty")
                .multilineTextAlignment(.center)
                .font(.title3Semibold)
                .foregroundStyle(Color.textWhite)

            Image("empty-inbox")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 176)

            Text("There are no new proposals from the followed DAOs")
                .multilineTextAlignment(.center)
                .font(.calloutRegular)
                .foregroundStyle(Color.textWhite)

            PrimaryButton("My followed DAOs") {
                pathManager.path.append(ProfileScreen.followedDaos)
            }

            Spacer()
        }
        .padding([.horizontal, .bottom], 16)
        .onAppear {
            Tracker.track(.screenInboxEmpty)
        }
    }
}
