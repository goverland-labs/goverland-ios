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
        VStack(spacing: 0) {
            Image("early-tester")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
                .frame(width: 250, height: 300)
                .background(Color.container)
                .cornerRadius(20)
                .padding(.vertical, 50)

            HStack {
                Spacer()
                Text(achievement.title)
                    .font(.titleSemibold)
                    .foregroundStyle(Color.textWhite)
                    .padding(.bottom)
                Spacer()
            }
            
            if let subtitle = achievement.subtitle {
                HStack {
                    Spacer()
                    Text(subtitle)
                        .font(.bodyRegular)
                        .foregroundStyle(Color.textWhite)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }

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
