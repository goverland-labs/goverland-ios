//
//  GroupedDaosDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 30.05.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation
import Combine

class GroupedDaosDataSource: ObservableObject, Refreshable {
    @Published var categoryDaos: [DaoCategory: [Dao]] = [:]
    @Published var failedToLoadInitialData: Bool = false
    @Published private var failedToLoadInCategory: [DaoCategory: Bool] = [:]

    private(set) var totalInCategory: [DaoCategory: Int] = [:]
    private(set) var totalLoadedInCategory: [DaoCategory: Int] = [:]
    private let paginationCount = ConfigurationManager.defaultPaginationCount

    private var cancellables = Set<AnyCancellable>()

    static let dashboard = GroupedDaosDataSource()
    static let search = GroupedDaosDataSource()
    static let addSubscription = GroupedDaosDataSource()

    private init() {}

    func refresh() {
        categoryDaos = [:]
        failedToLoadInitialData = false
        failedToLoadInCategory = [:]
        totalInCategory = [:]
        totalLoadedInCategory = [:]
        cancellables = Set<AnyCancellable>()

        loadInitialData()
    }

    private func loadInitialData() {
        APIService.topDaos()
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] result, headers in
                guard let self else { return }
                result.forEach { (key: String, value: DaoTopEndpoint.GroupedDaos) in
                    guard let category = DaoCategory(rawValue: key) else { return }
                    self.categoryDaos[category] = value.list
                    self.totalInCategory[category] = value.count
                    self.totalLoadedInCategory[category] = self.paginationCount
                }
            }
            .store(in: &cancellables)
    }

    func loadMore(category: DaoCategory) {
        APIService.daos(offset: offset(category: category), limit: paginationCount, category: category)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInCategory[category] = true
                }
            } receiveValue: { [weak self] result, headers in
                guard let self else { return }
                self.failedToLoadInCategory[category] = false
                if self.categoryDaos[category] != nil {
                    let appended = self.categoryDaos[category]!.appendUnique(contentsOf: result)
                    self.totalLoadedInCategory[category, default: 0] += paginationCount
                } else {
                    self.categoryDaos[category] = result
                    self.totalLoadedInCategory[category] = paginationCount
                }

                self.totalInCategory[category] = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }

    func retryLoadMore(category: DaoCategory) {
        // This will trigger view update cycle that will trigger `loadMore` function
        self.failedToLoadInCategory[category] = false
    }

    func hasMore(category: DaoCategory) -> Bool {
        guard let total = totalInCategory[category],
                let loaded = totalLoadedInCategory[category] else {
            return true
        }
        return loaded < total
    }

    func failedToLoad(category: DaoCategory) -> Bool {
        return failedToLoadInCategory[category] ?? false
    }

    private func offset(category: DaoCategory) -> Int {
        return totalLoadedInCategory[category] ?? 0
    }
}
