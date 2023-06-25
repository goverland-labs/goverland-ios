//
//  DaoInfoDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-25.
//

import SwiftUI
import Combine

class DaoInfoDataSource: ObservableObject, Refreshable {
    private let daoID: UUID
    
    @Published var dao: Dao?
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()

    init(daoID: UUID) {
        self.daoID = daoID
        refresh()
    }

    convenience init(dao: Dao) {
        self.init(daoID: dao.id)
        self.dao = dao
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
        APIService.daoInfo(id: daoID)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] dao, headers in
                self?.dao = dao
            }
            .store(in: &cancellables)
    }
}
