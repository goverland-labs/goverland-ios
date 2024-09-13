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
    let delegateId: Address

    @Published var proposals: [Proposal]?
    @Published var total: Int?
    @Published var failedToLoadInitialData = false
    @Published var failedToLoadMore = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    init(delegateId: Address) {
        self.delegateId = delegateId
    }
    
    func refresh() {
        proposals = nil
        total = nil
        failedToLoadInitialData = false
        failedToLoadMore = false
        isLoading = false
        cancellables = Set<AnyCancellable>()
        
        loadInitialData()
    }
    
    private func loadInitialData() {
        isLoading = true
        APIService.daoDelegateVotes(delegateId: delegateId)
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
    
    // TODO: double-check logic
    func loadMore() {
        APIService.daoDelegateVotes(delegateId: delegateId, offset: proposals?.count ?? 0)
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
        failedToLoadMore = true
    }

    func hasMore() -> Bool {
        guard let total = total else { return true }
        return proposals?.count ?? 0 < total
    }
}
