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

    var locked: Bool {
        achievement.achievedAt == nil
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ZStack {
                    let size = Avatar.Size.l.achievementImageSize
                    let cornerRadius: CGFloat = 20
                    if locked {
                        ShimmerView()
                            .frame(width: size.width, height: size.height)
                            .cornerRadius(cornerRadius)

                        Image(systemName: "lock.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(Color.textWhite60)
                    } else {
                        RectanglePictureView(image: achievement.image(size: .l),
                                             imageSize: size,
                                             cornerRadius: cornerRadius)
                    }
                }
                .padding(.bottom, 16)

                Text(achievement.subtitle)
                    .font(.сaptionRegular)
                    .foregroundStyle(Color.textWhite60)
                    .multilineTextAlignment(.center)

                if locked {
                    AchievementProgressView(progress: achievement.progress)
                        .padding(.top, 12)
                } else {
                    Text("Unlocked on \(Utils.shortDateWithoutTime(achievement.achievedAt!))")
                        .font(.сaptionRegular)
                        .foregroundStyle(Color.textWhite60)
                        .padding(.top, 4)

                    Text(achievement.message)
                        .font(.subheadlineRegular)
                        .foregroundStyle(Color.textWhite)
                        .multilineTextAlignment(.center)
                        .padding(.top, 12)
                }
            }
            .padding(.vertical, 16)
        }
        .scrollIndicators(.hidden)
        .navigationTitle(achievement.title)
        .padding(.horizontal, Constants.horizontalPadding)
        .onAppear {
            Tracker.track(.screenAchievementDetails)
            AchievementsDataSource.shared.markRead(achievementId: achievement.id)
        }
    }
}
