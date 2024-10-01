//
//  CategoryDaosDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.05.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation
import Combine

class CategoryDaosDataSource: ObservableObject, Refreshable, Paginatable {
    private let category: DaoCategory
    private let limit = ConfigurationManager.defaultPaginationCount

    @Published var daos: [Dao] = []
    @Published var failedToLoadInitialData = false
    @Published var failedToLoadMore = false
    @Published var isLoading = false

    private(set) var total: Int?
    private var totalSkipped: Int?

    private var cancellables = Set<AnyCancellable>()

    @Published var searchText = ""
    @Published var searchResultDaos: [Dao] = []
    @Published var nothingFound: Bool = false
    private var searchCancellable: AnyCancellable?

    init(category: DaoCategory) {
        self.category = category
        searchCancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.performSearch(searchText)
            }
    }

    func refresh() {
        daos = []
        failedToLoadInitialData = false
        failedToLoadMore = false
        total = nil
        totalSkipped = nil
        cancellables = Set<AnyCancellable>()

        searchText = ""
        searchResultDaos = []
        nothingFound = false
        // do not clear searchCancellable

        loadInitialData()
    }

    private func loadInitialData() {
        isLoading = true
        APIService.daos(limit: limit, category: category)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] daos, headers in
                guard let self else { return }
                self.daos = daos
                self.total = Utils.getTotal(from: headers)
                self.totalSkipped = 0
            }
            .store(in: &cancellables)
    }

    func loadMore() {
        APIService.daos(offset: daos.count, limit: limit, category: category)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadMore = true
                }
            } receiveValue: { [weak self] result, headers in
                guard let self else { return }
                self.failedToLoadMore = false
                let appended = self.daos.appendUnique(contentsOf: result)
                self.total = Utils.getTotal(from: headers)
                self.totalSkipped! += limit - appended
            }
            .store(in: &cancellables)
    }

    private func performSearch(_ searchText: String) {
        nothingFound = false
        guard searchText != "" else { return }

        APIService.daos(category: category, query: searchText)
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

    func retryLoadMore() {
        // This will trigger view update cycle that will trigger `loadMore` function
        self.failedToLoadMore = false
    }

    func hasMore() -> Bool {
        guard let total = total, let totalSkipped = totalSkipped else { return true }
        return daos.count < total - totalSkipped
    }
}
