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
                        _AchievementView(achievement: achievement)
                    }
                }
            }
            .padding(.vertical, 12)
        }
        .refreshable {
            dataSource.refresh()
        }
    }
}

fileprivate struct _AchievementView: View {
    let achievement: Achievement

    var locked: Bool {
        achievement.achievedAt == nil
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                let size = Avatar.Size.s.achievementImageSize
                let cornerRadius = size.width / 8
                if locked {
                    ShimmerView()
                        .frame(width: size.width, height: size.height)
                        .cornerRadius(cornerRadius)

                    Image(systemName: "lock.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.textWhite60)
                } else {
                    RectanglePictureView(image: achievement.image(size: .s),
                                         imageSize: size,
                                         cornerRadius: cornerRadius)
                }
            }

            VStack(alignment: .leading) {
                Text(achievement.title)
                    .font(.subheadlineSemibold)
                    .foregroundStyle(Color.textWhite)
                Text(achievement.subtitle)
                    .font(.caption)
                    .foregroundStyle(Color.textWhite60)

                Spacer()

                if locked {
                    let goal = achievement.progress.goal
                    let current = achievement.progress.current
                    HStack {
                        if goal > 1 {
                            ProgressBarView(score: current, totalScore: goal, height: 4)
                                .frame(height: 4)
                            Text("\(String(format: "%.0f", current)) of \(String(format: "%.0f", goal))")
                                .foregroundStyle(Color.textWhite60)
                                .font(.сaption2Regular)
                        } else {
                            Spacer()
                        }
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

                        Spacer()
                    }
                }
            }
            .padding(.vertical, 16)
            .multilineTextAlignment(.leading)
        }
        .frame(height: 116)
        .padding(.leading, Constants.horizontalPadding)
        .padding(.trailing, 20)
        .background(Color.container)
        .cornerRadius(20)
    }
}
