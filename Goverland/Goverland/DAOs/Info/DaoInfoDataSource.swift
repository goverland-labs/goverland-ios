//
//  DaoInfoDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-25.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation
import Combine

class DaoInfoDataSource: ObservableObject, Refreshable {
    private let daoId: String
    
    @Published var dao: Dao?
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    init(daoId: String) {
        self.daoId = daoId
        NotificationCenter.default.addObserver(self, selector: #selector(authTokenChanged(_:)), name: .authTokenChanged, object: nil)
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
    
    @objc func authTokenChanged(_ notification: Notification) {
        // Andrey (22.08.2024): this will cause navigating back from navigation stack in Activity
        // but this is ok
        refresh()
    }
}
