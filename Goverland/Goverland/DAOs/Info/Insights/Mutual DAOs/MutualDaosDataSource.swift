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
    @Published var failedToLoadMore: Bool = false
    private(set) var totalDaos: Int?
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
        failedToLoadMore = false
        totalDaos = nil
        cancellables = Set<AnyCancellable>()

        loadInitialData()
    }

    private func loadInitialData() {
        APIService.mutualDaos(id: daoID)
            .sink { [weak self] completion in
                print(completion)
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] result, headers in
                print(result)
                print(headers)
                self?.totalDaos = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }
    
    func hasMore() -> Bool {
        guard let total = totalDaos else { return true }
        return mutualDaos.count < total
    }
    
    func retryLoadMore() {
        // This will trigger view update cycle that will trigger `loadMore` function
        self.failedToLoadMore = false
    }

    func loadMore() {
        APIService.mutualDaos(id: daoID, offset: mutualDaos.count)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadMore = true
                }
            } receiveValue: { [weak self] result, headers in
                guard let `self` = self else { return }
                self.failedToLoadMore = false
                self.mutualDaos.append(contentsOf: result)
                self.totalDaos = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }
}
