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
    private(set) var totalInCategory: [DaoCategory: Int] = [:]
    private(set) var totalDaos: Int?
    private var cancellables = Set<AnyCancellable>()

    @Published var searchText = ""
    @Published var searchResultDaos: [Dao] = []
    @Published var nothingFound: Bool = false
    private var searchCancellable: AnyCancellable?

    init() {
        searchCancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.performSearch(searchText)
            }
    }

    func refresh() {
        categoryDaos = [:]
        failedToLoadInitially = false
        failedToLoadInCategory = [:]
        totalInCategory = [:]
        totalDaos = nil
        cancellables = Set<AnyCancellable>()

        searchText = ""
        searchResultDaos = []
        nothingFound = false
        // do not clear searchCancellable

        loadInitialData()
    }

    private func loadInitialData() {
        APIService.daoGrouped()
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitially = true
                }
            } receiveValue: { [weak self] result, headers in
                result.forEach { (key: String, value: DaoGroupedEndpoint.GroupedDaos) in
                    let category = DaoCategory(rawValue: key)!
                    self?.categoryDaos[category] = value.list
                    self?.totalInCategory[category] = value.count
                }
                guard let totalStr = headers["x-total-count"] as? String,
                    let total = Int(totalStr) else {
                    // TODO: log in crashlytics
                    return
                }
                self?.totalDaos = total
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

                guard let totalStr = headers["x-total-count"] as? String,
                    let total = Int(totalStr) else {
                    // TODO: log in crashlytics
                    return
                }
                self?.totalInCategory[category] = total
            }
            .store(in: &cancellables)
    }

    private func performSearch(_ searchText: String) {
        nothingFound = false
        guard searchText != "" else { return }

        APIService.daos(query: searchText)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.nothingFound = true
                }
            } receiveValue: { [weak self] result, headers in
                self?.nothingFound = result.isEmpty
                self?.searchResultDaos = result
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
