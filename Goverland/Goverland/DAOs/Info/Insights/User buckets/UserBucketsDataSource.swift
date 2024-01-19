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
    private let dao: Dao

    @Published var userBuckets: [UserBuckets] = []
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()

    var groups: String {
        var arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900, 950, 1000]
        return arr.dropFirst().reduce("1") { r, next in
            if next <= dao.proposals {
                return "\(r),\(next)"
            }
            return r
        }
    }

    init(dao: Dao) {
        self.dao = dao
    }
    
    func refresh() {
        userBuckets = []
        failedToLoadInitialData = false
        isLoading = true
        cancellables = Set<AnyCancellable>()
        loadInitialData()
    }
    
    private func loadInitialData() {
        APIService.userBuckets(id: dao.id, groups: groups)
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
