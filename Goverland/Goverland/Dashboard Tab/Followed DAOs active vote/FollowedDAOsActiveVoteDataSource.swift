//
//  FollowedDAOsActiveVoteDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 24.01.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class FollowedDAOsActiveVoteDataSource: ObservableObject, Refreshable {
    @Published var subscriptions: [Subscription] = []
    @Published var failedToLoadInitialData: Bool = false
    @Published var isLoading: Bool = true
    private var cancellables = Set<AnyCancellable>()

    static let dashboard = FollowedDAOsActiveVoteDataSource()
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(subscriptionDidToggle(_:)), name: .subscriptionDidToggle, object: nil)
    }

    @objc private func subscriptionDidToggle(_ notification: Notification) {
        refresh()
    }

    func refresh() {
        subscriptions = []
        isLoading = false
        failedToLoadInitialData = false
        cancellables = Set<AnyCancellable>()
        loadInitialData()
    }

    private func loadInitialData() {
        guard !SettingKeys.shared.authToken.isEmpty else { return }

        isLoading = true
        APIService.subscriptions()
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] subscriptions, _ in
                self?.subscriptions = subscriptions.filter { ($0.dao.activeVotes ?? 0) > 0 }
            }
            .store(in: &cancellables)
    }
}
