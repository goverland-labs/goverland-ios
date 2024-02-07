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
            ZStack {
                Image(achievement.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    
                if !achievement.isVisible {
                    VisualEffectView(effect: UIBlurEffect(style: .dark))
                        .cornerRadius(20)
                        .opacity(0.95)
                }
            }
            .frame(height: 350)
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
            
        }
        .padding(.horizontal, 50)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Achievements")
                        .font(.title3Semibold)
                        .foregroundColor(Color.textWhite)
                }
            }
        }
        
        Spacer()
    }
}
