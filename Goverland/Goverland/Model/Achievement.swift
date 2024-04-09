//
//  Achievement.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-04-04.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation

struct Achievement: Identifiable, Decodable {
    let id: String
    let title: String
    let subtitle: String
    let description: String
    let message: String
    let images: [Avatar]
    let progress: Progress
    let achievedAt: Date?
    let viewedAt: Date?
    let exclusive: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case description
        case message = "achievement_message"
        case images
        case progress
        case achievedAt = "achieved_at"
        case viewedAt = "viewed_at"
        case exclusive
    }

    struct Progress: Decodable {
        let goal: Double
        let current: Double
    }

    func image(size: Avatar.Size) -> URL? {
        images.first(where: { $0.size == size })?.link
    }
}
