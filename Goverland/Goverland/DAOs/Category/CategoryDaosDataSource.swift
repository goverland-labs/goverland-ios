//
//  CategoryDaosDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.05.23.
//

import Foundation
import Combine

class CategoryDaosDataSource: ObservableObject, Refreshable {
    private let category: DaoCategory

    @Published var daos: [Dao] = []
    @Published var failedToLoadInitialData = false
    @Published var failedToLoadMore = false
    private(set) var total: Int?
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
        cancellables = Set<AnyCancellable>()

        searchText = ""
        searchResultDaos = []
        nothingFound = false
        // do not clear searchCancellable

        loadInitialData()
    }

    private func loadInitialData() {
        APIService.daos(category: category)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] daos, headers in
                self?.daos = daos
                self?.total = self?.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }

    func loadMore() {
        APIService.daos(offset: daos.count, category: category)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadMore = true
                }
            } receiveValue: { [weak self] result, headers in
                self?.failedToLoadMore = false
                self?.daos.appendUnique(contentsOf: result)
                self?.total = self?.getTotal(from: headers)
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

    private func getTotal(from headers: HttpHeaders) -> Int? {
        guard let totalStr = headers["x-total-count"] as? String,
            let total = Int(totalStr) else {
            // TODO: log in crashlytics
            return nil
        }
        return total
    }

    func hasMore() -> Bool {
        guard let total = total else { return true }
        return daos.count < total
    }
}
