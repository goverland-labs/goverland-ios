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
}

class AchievementsDataSource: ObservableObject {
    let achievements = [
        Achievement(imageName: "early-tester",
                    isVisible: true,
                    title: "Early Tester",
                    subtitle: "It is awarded to our App early TestFlight users.\n\nThank you for trying us so early! 🙏"),
        Achievement(imageName: "", isVisible: false, title: "", subtitle: nil),
        Achievement(imageName: "", isVisible: false, title: "", subtitle: nil),
        Achievement(imageName: "", isVisible: false, title: "", subtitle: nil),
        Achievement(imageName: "", isVisible: false, title: "", subtitle: nil),
        Achievement(imageName: "", isVisible: false, title: "", subtitle: nil)
    ]
    
    init() {}
}
