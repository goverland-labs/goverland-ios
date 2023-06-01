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
    private var total: Int?
    private var cancellables = Set<AnyCancellable>()

    init(category: DaoCategory) {
        self.category = category
    }

    func refresh() {
        daos = []
        failedToLoadInitialData = false
        failedToLoadMore = false
        total = nil
        cancellables = Set<AnyCancellable>()

        loadInitialData()
    }

    private func loadInitialData() {
        APIService.daos(category: category)
            .sink { [unowned self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self.failedToLoadInitialData = true
                }
            } receiveValue: { [unowned self] daos, headers in
                self.daos = daos
                self.total = getTotal(from: headers)
            }
            .store(in: &cancellables)
    }

    func loadMore() {
        APIService.daos(offset: daos.count, category: category)
            .sink { [unowned self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self.failedToLoadMore = true
                }
            } receiveValue: { [unowned self] result, headers in
                self.failedToLoadMore = false
                self.daos.append(contentsOf: result)
                self.total = self.getTotal(from: headers)
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
