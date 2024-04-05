//
//  AchievementsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-02-05.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

struct AchievementsView: View {
    @ObservedObject var dataScource = AchievementsDataSource.shared
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(dataScource.achievements) { (achievement: Achievement) in
                    // TODO: remove in public release
                    NavigationLink(destination: AchievementDetailView(achievement: achievement)) {
                        HStack(spacing: 0) {
                            Image("early-tester")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipped()
                                .padding()
                            
                            VStack(alignment: .leading) {
                                Text(achievement.title)
                                    .font(.subheadlineSemibold)
                                    .foregroundStyle(Color.textWhite)
                                Text(achievement.subtitle ?? "")
                                    .font(.caption)
                                    .foregroundStyle(Color.textWhite60)
                                
                                Spacer()
                                
                                HStack {
//                                    if achievement.achievedAt != nil {
//                                        BubbleView(image: Image(systemName: "checkmark"),
//                                                   text: Text("Unlocked"),
//                                                   textColor: .textWhite,
//                                                   backgroundColor: .success)
//                                    }
                                    if achievement.exlusive {
                                        BubbleView(image: Image(systemName: "heart"),
                                                   text: Text("Exclusive"),
                                                   textColor: .textWhite,
                                                   backgroundColor: .warning)
                                    }
                                }
                            }
                            .padding()
                            .multilineTextAlignment(.leading)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .background(Color.container)
                        .cornerRadius(20)
                        
                    }
                }
            }
            .padding(.top, 10)
        }
        .onAppear() {
            Tracker.track(.screenAchievements)
            if dataScource.achievements.isEmpty {
                dataScource.loadAchievements()
            }
        }
    }
}
