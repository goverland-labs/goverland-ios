//
//  DaoDelegateProfileActivityDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-09-12.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class DaoDelegateProfileActivityDataSource: ObservableObject, Refreshable, Paginatable {
    let daoId: String
    let delegateId: String

    @Published var proposals: [Proposal]?
    @Published var failedToLoadInitialData = false
    @Published var failedToLoadMore = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()

    private var total: Int?

    init(daoId: String, delegateId: String) {
        self.daoId = daoId
        self.delegateId = delegateId
    }
    
    func refresh() {
        proposals = nil
        failedToLoadInitialData = false
        failedToLoadMore = false
        isLoading = false
        cancellables = Set<AnyCancellable>()
        total = nil

        loadInitialData()
    }
    
    private func loadInitialData() {
        isLoading = true
        APIService.daoDelegateVotes(daoId: daoId, delegateId: delegateId)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] proposals, headers in
                self?.proposals = proposals
                self?.total = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }
    
    func loadMore() {
        APIService.daoDelegateVotes(daoId: daoId, delegateId: delegateId, offset: proposals?.count ?? 0)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] proposals, headers in
                self?.proposals?.append(contentsOf: proposals)
                self?.total = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }
    
    func retryLoadMore() {
        // This will trigger view update cycle that will trigger `loadMore` function
        failedToLoadMore = false
    }

    func hasMore() -> Bool {
        guard let proposals, let total = total else { return true }
        return proposals.count < total
    }
}
