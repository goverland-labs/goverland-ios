//
//  AchievementDetailView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-02-07.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

struct AchievementDetailView: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 5) {
            Image("early-tester")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
                .frame(width: 250, height: 300)
                .padding(.vertical, 50)
            
            Text(achievement.title)
                .font(.headlineSemibold)
                .foregroundStyle(Color.textWhite)
            
            Text(achievement.subtitle ?? "")
                .font(.caption)
                .foregroundStyle(Color.textWhite60)
//            
//            if achievement.achievedAt != nil {
//                Text("Unlocked on \(Utils.shortDateWithoutTime(achievement.achievedAt!))")
//                    .font(.caption)
//                    .foregroundStyle(Color.textWhite60)
//            }
            
            Text(achievement.message ?? "")
                .font(.subheadlineRegular)
                .foregroundStyle(Color.textWhite)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding(.horizontal, 20)
        .toolbar {
            ToolbarTitle("Achievements")            
        }
        .onAppear {
            Tracker.track(.screenAchievementDetails)
        }
    }
}
