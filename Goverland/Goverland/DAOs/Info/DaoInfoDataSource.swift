//
//  DaoInfoDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-25.
//

import SwiftUI
import Combine

class DaoInfoDataSource: ObservableObject {
    private let daoID: UUID
    
    @Published var dao: Dao = Dao.aave
    @Published var failedToLoadData = false
    private var cancellables = Set<AnyCancellable>()

    init(daoID: UUID) {
        self.daoID = daoID
    }

    func loadInitialData() {
        APIService.daoInfo(id: daoID)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadData = true
                }
            } receiveValue: { [weak self] dao, headers in
                self?.dao = dao
            }
            .store(in: &cancellables)
    }
}
