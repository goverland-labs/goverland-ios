//
//  AchievementProgressView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 09.04.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct AchievementProgressView: View {
    let progress: Achievement.Progress

    var body: some View {
        let goal = progress.goal
        let current = progress.current
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
    }
}
