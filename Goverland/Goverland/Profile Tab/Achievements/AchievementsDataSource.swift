//
//  AchievementsDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-02-07.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct Achievement: Identifiable, Hashable {
    let id = UUID()
    let imageName: String
    let isVisible: Bool
    let title: String
    let subtitle: String?
    let number: Int
}

class AchievementsDataSource: ObservableObject {
    
    let achievements = [
        Achievement(imageName: "first-tester", 
                    isVisible: true,
                    title: "First Tester",
                    subtitle: "Awarded to users who participate in the initial testing phase of our platform.",
                    number: 1),
        Achievement(imageName: "first-tester", isVisible: false, title: "Second Tester", subtitle: nil, number: 2),
        Achievement(imageName: "first-tester", isVisible: false, title: "Third Tester", subtitle: nil, number: 3),
        Achievement(imageName: "first-tester", isVisible: false, title: "Fourth Tester", subtitle: nil, number: 4),
        Achievement(imageName: "first-tester", isVisible: false, title: "Fifth Tester", subtitle: nil, number: 5),
        Achievement(imageName: "first-tester", isVisible: false, title: "Sixth Tester", subtitle: nil, number: 6)
    ]
    
    init() {}
}
