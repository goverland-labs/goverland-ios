//
//  FollowedDaosDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-17.
//

import Foundation
import Combine

class FollowedDaosDataSource: ObservableObject, Refreshable {
    @Published var daos: [Dao] = []
    @Published var failedToLoadInitialData = false
    private var cancellables = Set<AnyCancellable>()

    func refresh() {
        daos = []
        failedToLoadInitialData = false
        cancellables = Set<AnyCancellable>()
        loadInitialData()
    }

    private func loadInitialData() {
        APIService.followedDaos()
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] result, headers in
                result.forEach { followedDao in
                    var dao = followedDao.dao
                    dao.subscriptionMeta = followedDao.subscriptionMeta
                    self?.daos.append(dao)
                }
            }
            .store(in: &cancellables)
    }
}
