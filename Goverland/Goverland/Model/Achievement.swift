//
//  Achievement.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-04-04.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct Achievement: Identifiable, Codable {
    let id: String
    let title: String
    let subtitle: String?
    let description: String?
    let message: String?
    let image: String?
    let progress: AchievementProgress
    let achievedAt: Date?
    let viewedAt: Date?
    let exlusive: Bool
}

struct AchievementProgress: Codable {
    let goal: Int
    let current: Int
}
