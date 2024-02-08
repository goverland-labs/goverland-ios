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
                    // TODO: remove in public release
                    if !achievement.isVisible {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text("COMING SOON")
                                    .font(.headlineSemibold)
                                    .foregroundColor(.textWhite60)
                                Spacer()
                            }
                            Spacer()
                        }
                        .frame(height: 210)
                        .background(Color.container)
                        .cornerRadius(20)
                    } else {
                        NavigationLink(destination: AchievementDetailView(achievement: achievement)) {
                            VStack(spacing: 0) {
                                Image(achievement.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipped()
                                Spacer()
                                HStack {
                                    Spacer()
                                    Text(achievement.title)
                                        .font(.subheadlineSemibold)
                                        .foregroundColor(.textWhite)
                                        .padding(.bottom, 20)
                                    Spacer()
                                }
                                Spacer()
                            }
                            .frame(height: 210)
                            .background(Color.container)
                            .cornerRadius(20)
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
