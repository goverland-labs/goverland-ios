//
//  AchievementsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-02-05.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

struct AchievementsView: View {
    @ObservedObject var dataScource = AchievementsDataSource()
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(minimum: 100, maximum: 200), spacing: 15),
                GridItem(.flexible(minimum: 100, maximum: 200), alignment: .top)
            ], spacing: 15, content: {
                ForEach(dataScource.achievements) { achievement in
                    NavigationLink(destination: AchievementDetailView(achievement: achievement)) {
                        ZStack {
                            VStack(spacing: 0) {
                                Image(achievement.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipped()
                                
                                HStack {
                                    Spacer()
                                    Text(achievement.title)
                                        .font(.subheadlineSemibold)
                                        .foregroundColor(.textWhite)
                                        .padding(.bottom, 30)
                                    Spacer()
                                }
                            }
                            .background(Color.container)
                            .cornerRadius(20)
                            
                            if !achievement.isVisible {
                                VisualEffectView(effect: UIBlurEffect(style: .dark))
                                    .cornerRadius(20)
                                    .opacity(0.95)
                                
                                
                                HStack {
                                    Spacer()
                                    Text("COMMING SOON")
                                    Spacer()
                                }
                                .font(.headlineSemibold)
                                .foregroundColor(.textWhite60)
                            }
                        }
                    }
                }
            })
            .padding()
        }
        .onAppear() {
            //Tracker.track(.event name)
        }
    }
}

