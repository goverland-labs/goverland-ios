//
//  ProfileFollowedDAOsView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 03.02.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct ProfileFollowedDAOsView: View {
    let profile: Profile

    var body: some View {
        if profile.subscriptionsCount > 0 {
            VStack(spacing: 12) {
                HStack {
                    Text("My followed DAOs (\(profile.subscriptionsCount))")
                        .font(.title3Semibold)
                        .foregroundStyle(Color.textWhite)
                    Spacer()
                    NavigationLink(value: ProfileScreen.followedDaos) {
                        Image(systemName: "arrow.forward")
                            .font(.title3Semibold)
                            .foregroundStyle(Color.textWhite)
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, Constants.horizontalPadding * 2)

                FollowedDAOsHorizontalListView()
            }
        } else {
            NavigationLink(value: ProfileScreen.followedDaos) {
                HStack {
                    Text("My followed DAOs")
                    Spacer()
                    Text("\(profile.subscriptionsCount)")
                        .foregroundStyle(Color.textWhite60)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.textWhite60)
                }
                .padding(16)
            }
            .background(Color.container)
            .cornerRadius(20)
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.top, 16)
        }
    }
}
