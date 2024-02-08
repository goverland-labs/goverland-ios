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
            Image(achievement.imageName)
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
                    .foregroundColor(.textWhite)
                    .padding(.bottom)
                Spacer()
            }
            
            if let subtitle = achievement.subtitle {
                HStack {
                    Spacer()
                    Text(subtitle)
                        .font(.bodyRegular)
                        .foregroundColor(.textWhite)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Achievements")
                        .font(.title3Semibold)
                        .foregroundColor(Color.textWhite)
                }
            }
        }
        .onAppear {
            Tracker.track(.screenAchievementDetails)
        }
    }
}
