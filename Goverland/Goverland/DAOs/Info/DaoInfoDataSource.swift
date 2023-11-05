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
    private let daoID: UUID

    @Published var dao: Dao?
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()

    init(dao: Dao) {
        self.daoID = dao.id
        self.dao = dao
        // TODO: we have all info and this refresh is not needed,
        // but without it Nav Bar controls are jumping (seems like SwifUI bug)
        refresh()
    }

    init(daoID: UUID) {
        self.daoID = daoID
        refresh()
    }

    func refresh() {
        failedToLoadInitialData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()
        loadInitialData()
    }

    private func loadInitialData() {
        isLoading = true
        APIService.daoInfo(id: daoID)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] dao, headers in
                self?.dao = dao
                RecentlyViewedDaosDataSource.dashboard.refresh()
            }
            .store(in: &cancellables)
    }
}
