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
    @Published var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()

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
