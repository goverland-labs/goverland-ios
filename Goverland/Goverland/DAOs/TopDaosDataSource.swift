//
//  TopDaosDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 30.05.23.
//

import Foundation
import Combine

class TopDaosDataSource: ObservableObject {
    @Published var categoryDaos: [DaoCategory: [Dao]] = [:]
    @Published var failedToLoadInitially: Bool = false
    private var totalInCategory: [DaoCategory: Int] = [:]
    private var failedToLoadInCategory: [DaoCategory: Bool] = [:]

    private var cancellables = Set<AnyCancellable>()

    func loadInitialData() {
        categoryDaos = [:]
        failedToLoadInitially = false
        totalInCategory = [:]
        failedToLoadInCategory = [:]

        APIService.topDaos()
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
                    self.categoryDaos[category]!.append(contentsOf: result)
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
