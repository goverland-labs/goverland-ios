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
        Text(achievement.name)
    }
}

#Preview {
    AchievementDetailView(achievement: Achievement(imageName: "first-tester", isVisible: true, name: "First Tester", number: 0))
}
