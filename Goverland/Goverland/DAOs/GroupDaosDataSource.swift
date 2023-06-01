//
//  GroupDaosDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 30.05.23.
//

import Foundation
import Combine

class GroupDaosDataSource: ObservableObject, Refreshable {
    @Published var categoryDaos: [DaoCategory: [Dao]] = [:]
    @Published var failedToLoadInitially: Bool = false
    @Published private var failedToLoadInCategory: [DaoCategory: Bool] = [:]
    private var totalInCategory: [DaoCategory: Int] = [:]
    private var cancellables = Set<AnyCancellable>()

    func refresh() {
        categoryDaos = [:]
        failedToLoadInitially = false
        failedToLoadInCategory = [:]
        totalInCategory = [:]
        cancellables = Set<AnyCancellable>()

        loadInitialData()
    }

    private func loadInitialData() {
        APIService.daoGrouped()
            .sink { [unowned self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self.failedToLoadInitially = true
                }
            } receiveValue: { [unowned self] result, headers in
                result.forEach { (key: String, value: [Dao]) in
                    let category = DaoCategory(rawValue: key)!
                    self.categoryDaos[category] = value
                }
            }
            .store(in: &cancellables)
    }

    func loadMore(category: DaoCategory) {
        APIService.daos(offset: offset(category: category), category: category)
            .sink { [unowned self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self.failedToLoadInCategory[category] = true
                }
            } receiveValue: { [unowned self] result, headers in
                self.failedToLoadInCategory[category] = false

                if categoryDaos[category] != nil {
                    self.categoryDaos[category]!.appendUnique(contentsOf: result)
                } else {
                    self.categoryDaos[category] = result
                }

                guard let totalStr = headers["x-total-count"] as? String,
                    let total = Int(totalStr) else {
                    // TODO: log in crashlytics
                    return
                }
                totalInCategory[category] = total
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
