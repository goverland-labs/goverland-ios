//
//  AchievementsDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-02-07.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class AchievementsDataSource: ObservableObject {
    @Published var achievements: [Achievement] = []
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        mockAchievements()
        //loadAchievements()
    }
    
    private func loadAchievements() {
        isLoading = true
        APIService.getAchievements()
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] achievements, headers in
                self?.achievements = achievements
            }
            .store(in: &cancellables)
    }
    
    private func mockAchievements() {
        achievements = [
            Achievement(id: "voted-in-3-verified-dao",
                        title: "First Vote Cast",
                        subtitle: "Vote in 3 verified DAOs",
                        description: "Make your voice heard by casting your first vote in a verified DAO through the Goverland App. Begin your journey in decentralized decision-making today!",
                        message: "Congratulations! You've earned the 'First Vote Cast' achievement by participating in your first verified DAO vote through the Goverland App. \nYour engagement marks the start of your impactful journey in decentralized governance. Welcome aboard!",
                        image: "https://example.link",
                        progress: AchievementProgress(goal: 1, current: 0),
                        achievedAt: .now,
                        viewedAt: nil,
                        exlusive: false),
            Achievement(id: "early-tester",
                        title: "Early Tester",
                        subtitle: "Awarded to users who participate in the initial testing phase of our platform.",
                        description: "You earned this achievement by participating in the TestFlight App testing before our public launch./n/nThank you for being an early tester of Goverland Alpha! 🙏 ",
                        message: "Congratulations! You've earned the 'Early Tester' achievement 🙏 ",
                        image: nil,
                        progress: AchievementProgress(goal: 1, current: 1),
                        achievedAt: .now,
                        viewedAt: nil,
                        exlusive: true),
            Achievement(id: "voted-in-3-verified-dao",
                        title: "First Vote Cast",
                        subtitle: "Vote in 3 verified DAOs",
                        description: "Make your voice heard by casting your first vote in a verified DAO through the Goverland App. Begin your journey in decentralized decision-making today!",
                        message: "Congratulations! You've earned the 'First Vote Cast' achievement by participating in your first verified DAO vote through the Goverland App. \nYour engagement marks the start of your impactful journey in decentralized governance. Welcome aboard!",
                        image: "https://example.link",
                        progress: AchievementProgress(goal: 1, current: 0),
                        achievedAt: .now,
                        viewedAt: nil,
                        exlusive: false),
            Achievement(id: "early-tester",
                        title: "Early Tester",
                        subtitle: "Awarded to users who participate in the initial testing phase of our platform.",
                        description: "You earned this achievement by participating in the TestFlight App testing before our public launch./n/nThank you for being an early tester of Goverland Alpha! 🙏 ",
                        message: "Congratulations! You've earned the 'Early Tester' achievement 🙏 ",
                        image: nil,
                        progress: AchievementProgress(goal: 1, current: 1),
                        achievedAt: .now,
                        viewedAt: nil,
                        exlusive: true)
        ]
    }
}
