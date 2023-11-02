//
//  UserBucketsDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-09-11.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import Combine

class UserBucketsDataSource: ObservableObject, Refreshable {
    private let daoID: UUID
    
    @Published var userBuckets: [UserBuckets] = []
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    init(daoID: UUID) {
        self.daoID = daoID
    }
    
    convenience init(dao: Dao) {
        self.init(daoID: dao.id)
    }
    
    func refresh() {
        userBuckets = []
        failedToLoadInitialData = false
        isLoading = true
        cancellables = Set<AnyCancellable>()
        loadInitialData()
    }
    
    private func loadInitialData() {
        APIService.userBuckets(id: daoID)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] data, headers in
                self?.userBuckets = data
            }
            .store(in: &cancellables)
    }

    func votersInBucket(_ bucket: String) -> Int? {
        userBuckets.first { $0.votes == bucket }?.voters
    }
}
