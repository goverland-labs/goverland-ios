//
//  MutualDaosDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-02.
//  Copyright © Goverland Inc. All rights reserved.
//
	
import Foundation
import Combine

class MutualDaosDataSource: ObservableObject, Refreshable {
    private let daoID: UUID
    @Published var mutualDaos: [MutualDao] = []
    @Published var failedToLoadInitialData: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init(daoID: UUID) {
        self.daoID = daoID
    }
    
    convenience init(dao: Dao) {
        self.init(daoID: dao.id)
    }

    func refresh() {
        mutualDaos = []
        failedToLoadInitialData = false
        cancellables = Set<AnyCancellable>()

        loadInitialData()
    }

    private func loadInitialData() {
        APIService.mutualDaos(id: daoID, limit: 21)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] result, _ in
                self?.mutualDaos = result
            }
            .store(in: &cancellables)
    }
}
