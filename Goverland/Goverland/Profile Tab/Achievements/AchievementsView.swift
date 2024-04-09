//
//  AchievementsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-02-05.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

struct AchievementsView: View {
    @ObservedObject var dataSource = AchievementsDataSource.shared

    var body: some View {
        Group {
            if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the achievements")
            } else if dataSource.isLoading {
                ProgressView()
                    .foregroundStyle(Color.textWhite20)
                    .controlSize(.regular)
                Spacer()
            } else {
                _AchievementsListView(dataSource: dataSource)
            }
        }
        .onAppear() {
            Tracker.track(.screenAchievements)
            if dataSource.achievements.isEmpty {
                dataSource.refresh()
            }
        }
    }
}

fileprivate struct _AchievementsListView: View {
    @ObservedObject var dataSource: AchievementsDataSource

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(dataSource.achievements) { achievement in
                    NavigationLink(destination: AchievementDetailView(achievement: achievement)) {
                        HStack(spacing: 12) {
                            RectanglePictureView(image: achievement.image(size: .s), 
                                                 imageSize: Avatar.Size.s.achievementImageSize)

                            VStack(alignment: .leading) {
                                Text(achievement.title)
                                    .font(.subheadlineSemibold)
                                    .foregroundStyle(Color.textWhite)
                                Text(achievement.subtitle)
                                    .font(.caption)
                                    .foregroundStyle(Color.textWhite60)

                                Spacer()

                                if achievement.achievedAt == nil {
                                    if achievement.progress.goal > 1 {
                                        // Draw progress bar
                                    }
                                } else {
                                    HStack(spacing: 8) {
                                        BubbleView(image: Image(systemName: "checkmark"),
                                                   text: Text("Unlocked"),
                                                   textColor: .textWhite,
                                                   backgroundColor: .success)

                                        if achievement.exclusive {
                                            BubbleView(image: Image(systemName: "heart"),
                                                       text: Text("Exclusive"),
                                                       textColor: .textWhite,
                                                       backgroundColor: .warning)
                                        }
                                    }
                                }
                            }
                            .padding(.vertical, 16)
                            .multilineTextAlignment(.leading)

                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 116)
                        .padding(.horizontal, Constants.horizontalPadding)
                        .background(Color.container)
                        .cornerRadius(20)
                    }
                }
            }
            .padding(.top, 12)
        }
        .refreshable {
            dataSource.refresh()
        }
    }
}
