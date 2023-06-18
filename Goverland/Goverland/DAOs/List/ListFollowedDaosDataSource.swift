//
//  ListFollowedDaosDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-17.
//

import Foundation
import Combine

class ListFollowedDaosDataSource: ObservableObject, Refreshable {
    @Published var daos: [Dao] = []
    @Published var failedToLoadInitialData = false
    private(set) var total: Int?
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
        daos = []
        failedToLoadInitialData = false
        total = nil
        cancellables = Set<AnyCancellable>()

        searchText = ""
        searchResultDaos = []
        nothingFound = false
        // do not clear searchCancellable

        loadInitialData()
    }

    private func loadInitialData() {
        APIService.daoFollowed()
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] result, headers in
                result.forEach { followedDao in
                    var dao = followedDao.dao
                    dao.subscriptionMeta = SubscriptionMeta(id: followedDao.id, createdAt: followedDao.created_at)
                    self?.daos.append(dao)
                }
                self?.total = self?.getTotal(from: headers)
                
                guard let totalStr = headers["x-total-count"] as? String,
                    let total = Int(totalStr) else {
                    // TODO: log in crashlytics
                    return
                }
                self?.total = total
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

    private func getTotal(from headers: HttpHeaders) -> Int? {
        guard let totalStr = headers["x-total-count"] as? String,
            let total = Int(totalStr) else {
            // TODO: log in crashlytics
            return nil
        }
        return total
    }
}
