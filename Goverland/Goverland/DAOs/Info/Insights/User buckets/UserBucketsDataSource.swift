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

    @Published var selectedFilteringOption: BucketGroupsFilteringOption = .one {
        didSet {
            refresh(invalidateCache: false)
        }
    }

    @Published var userBuckets: [UserBuckets] = []
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()

    var groups: String {
        var arr = Array(
            stride(from: selectedFilteringOption.rawValue,
                   through: selectedFilteringOption.rawValue * 15, 
                   by: selectedFilteringOption.rawValue)
        )
        if selectedFilteringOption != .one {
            arr.insert(contentsOf: [1], at: 0)
        }
        let first = arr[0]
        return arr.dropFirst().reduce("\(first)") { r, next in
            if next <= dao.proposals {
                return "\(r),\(next)"
            }
            return r
        }
    }

    private var cache: [BucketGroupsFilteringOption: [UserBuckets]] = [:]

    init(dao: Dao) {
        self.dao = dao
    }

    func refresh() {
        refresh(invalidateCache: true)
    }

    private func refresh(invalidateCache: Bool) {
        if let cachedData = cache[selectedFilteringOption], !invalidateCache {
            userBuckets = cachedData
            return
        }

        if invalidateCache {
            cache = [:]
        }

        userBuckets = []
        failedToLoadInitialData = false
        isLoading = true
        cancellables = Set<AnyCancellable>()
        loadData()
    }
    
    private func loadData() {
        APIService.userBuckets(id: dao.id, groups: groups)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] data, headers in
                guard let self else { return }
                self.userBuckets = data
                self.cache[selectedFilteringOption] = data
            }
            .store(in: &cancellables)
    }

    func votersInBucket(_ bucket: String) -> Int? {
        userBuckets.first { $0.votes == bucket }?.voters
    }
}
