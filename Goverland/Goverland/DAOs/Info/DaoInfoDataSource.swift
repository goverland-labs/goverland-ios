//
//  DaoInfoDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-25.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import Combine

class DaoInfoDataSource: ObservableObject, Refreshable {
    private let daoId: String

    @Published var dao: Dao?
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()

    init(dao: Dao) {
        self.daoId = dao.id.uuidString
        self.dao = dao
        // TODO: we have all info and this refresh is not needed,
        // but without it Nav Bar controls are jumping (seems like SwifUI bug)
        refresh()
    }

    init(daoId: String) {
        self.daoId = daoId
        refresh()
    }

    func refresh() {
        dao = nil
        failedToLoadInitialData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()
        loadInitialData()
    }

    private func loadInitialData() {
        isLoading = true
        APIService.daoInfo(daoId: daoId)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] dao, headers in
                self?.dao = dao
                RecentlyViewedDaosDataSource.search.refresh()
            }
            .store(in: &cancellables)
    }
}
