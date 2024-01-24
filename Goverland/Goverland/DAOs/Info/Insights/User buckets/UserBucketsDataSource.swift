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
        let arr = Array(stride(from: 1, through: 15, by: 1))
        let first = arr[0]
        return arr.dropFirst().reduce("\(first)") { r, next in
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
