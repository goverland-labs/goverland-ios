//
//  AchievementsDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-02-07.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class AchievementsDataSource: ObservableObject, Refreshable {
    @Published var achievements: [Achievement] = []
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    static let shared = AchievementsDataSource()

    func refresh() {
        achievements = []
        failedToLoadInitialData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()

        loadAchievements()
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

    func markRead(achievementId: String) {
        APIService.markAchievementRead(achievementId: achievementId)
            .retry(3)
            .sink { _ in
                // do nothing
            } receiveValue: { [weak self] _, headers in
                // update achievements lits to reflect unread indicator status
                self?.refresh()
            }
            .store(in: &cancellables)
    }

    func hasUnreadAchievements() -> Bool {
        achievements.reduce(false) { r, a in r || a.isUnread }
    }
}
