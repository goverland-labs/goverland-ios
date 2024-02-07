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
    let name: String
    let number: Int
}

class AchievementsDataSource: ObservableObject {
    
    let achievements = [
        Achievement(imageName: "first-tester", isVisible: true, name: "First Tester", number: 1),
        Achievement(imageName: "first-tester", isVisible: false, name: "Second Tester", number: 2),
        Achievement(imageName: "first-tester", isVisible: false, name: "Third Tester", number: 3),
        Achievement(imageName: "first-tester", isVisible: true, name: "Fourth Tester", number: 4),
        Achievement(imageName: "first-tester", isVisible: false, name: "Fifth Tester", number: 5),
        Achievement(imageName: "first-tester", isVisible: false, name: "Sixth Tester", number: 6)
    ]
    
    init() {}
}
