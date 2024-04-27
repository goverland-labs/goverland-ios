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
                result.forEach { (key: String, value: DaoTopEndpoint.GroupedDaos) in
                    if let category = DaoCategory(rawValue: key) {
                        self?.categoryDaos[category] = value.list
                        self?.totalInCategory[category] = value.count
                    }
                }
            }
            .store(in: &cancellables)
    }

    func loadMore(category: DaoCategory) {
        APIService.daos(offset: offset(category: category), category: category)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInCategory[category] = true
                }
            } receiveValue: { [weak self] result, headers in
                self?.failedToLoadInCategory[category] = false

                if self?.categoryDaos[category] != nil {
                    self?.categoryDaos[category]!.appendUnique(contentsOf: result)
                } else {
                    self?.categoryDaos[category] = result
                }

                self?.totalInCategory[category] = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }

    func retryLoadMore(category: DaoCategory) {
        // This will trigger view update cycle that will trigger `loadMore` function
        self.failedToLoadInCategory[category] = false
    }

    func hasMore(category: DaoCategory) -> Bool {
        guard let count = categoryDaos[category]?.count,
            let total = totalInCategory[category] else {
            return true
        }
        return count < total
    }

    func failedToLoad(category: DaoCategory) -> Bool {
        return failedToLoadInCategory[category] ?? false
    }

    private func offset(category: DaoCategory) -> Int {
        return categoryDaos[category]?.count ?? 0
    }
}
