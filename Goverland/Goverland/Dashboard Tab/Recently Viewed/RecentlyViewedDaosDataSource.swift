//
//  RecentlyViewedDaosDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-27.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation
import Combine

class RecentlyViewedDaosDataSource: ObservableObject, Refreshable {
    @Published var recentlyViewedDaos: [Dao] = []
    @Published var failedToLoadInitialData: Bool = false
    private var cancellables = Set<AnyCancellable>()

    static let dashboard = RecentlyViewedDaosDataSource()

    private init() {}

    func refresh() {
        recentlyViewedDaos = []
        failedToLoadInitialData = false
        cancellables = Set<AnyCancellable>()

        loadInitialData()
    }

    private func loadInitialData() {
        APIService.recentlyViewedDaos()
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] result, _ in
                self?.recentlyViewedDaos = result
            }
            .store(in: &cancellables)
    }
}