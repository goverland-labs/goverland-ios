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

    private init() {}

    func refresh() {
        subscriptions = []
        isLoading = false
        failedToLoadInitialData = false
        cancellables = Set<AnyCancellable>()
        loadInitialData()
    }

    private func loadInitialData() {
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
