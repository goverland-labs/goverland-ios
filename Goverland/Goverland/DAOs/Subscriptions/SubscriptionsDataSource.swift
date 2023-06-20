//
//  SubscriptionsDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-17.
//

import Foundation
import Combine

class SubscriptionsDataSource: ObservableObject, Refreshable {
    @Published var subscriptions: [Subscription] = []
    @Published var failedToLoadInitialData = false
    private var cancellables = Set<AnyCancellable>()

    func refresh() {
        subscriptions = []
        failedToLoadInitialData = false
        cancellables = Set<AnyCancellable>()
        loadInitialData()
    }

    private func loadInitialData() {
        APIService.subscriptions()
            .sink { [weak self] completion in
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
