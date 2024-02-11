//
//  FollowedDaosDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-17.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation
import Combine

class FollowedDaosDataSource: ObservableObject, Refreshable {
    @Published var subscriptions: [Subscription] = []
    @Published var failedToLoadInitialData = false
    @Published var isLoading: Bool = true
    private var cancellables = Set<AnyCancellable>()

    static let followedDaos = FollowedDaosDataSource()
    static let profileHorizontalList = FollowedDaosDataSource()

    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(authTokenChanged(_:)), name: .authTokenChanged, object: nil)
    }

    @objc private func authTokenChanged(_ notification: Notification) {
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
            } receiveValue: { [weak self] subscriptions, headers in
                self?.subscriptions = subscriptions
            }
            .store(in: &cancellables)
    }
}
