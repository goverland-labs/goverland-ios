//
//  GuestAchievementsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-02-07.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct GuestAchievementsView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 24) {
                Spacer()
                Image("guest-profile-achieviments")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width / 2)
                Text("Achievements are only available to signed-in users.")
                    .font(.calloutRegular)
                    .foregroundStyle(Color.textWhite)
                    .padding(.horizontal, 20)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .frame(width: geometry.size.width - 32)
            .padding(.horizontal, 16)
            .onAppear {
                Tracker.track(.screenGuestAchievements)
            }
        }
    }
}
