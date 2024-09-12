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
    let delegateID: Address
    
    @Published var votes: [Proposal] = []
    @Published var total: Int?
    @Published var failedToLoadInitialData = false
    @Published var failedToLoadMore = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    init(delegateID: Address) {
        self.delegateID = delegateID
    }
    
    func refresh() {
        votes = []
        total = nil
        failedToLoadInitialData = false
        failedToLoadMore = false
        isLoading = false
        cancellables = Set<AnyCancellable>()
        
        loadInitialData()
    }
    
    private func loadInitialData() {
        isLoading = true
        APIService.daoDelegateVotes(delegateId: delegateID)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] votes, headers in
                self?.votes = votes
                print(votes)
                self?.total = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }
    
    func loadMore() {
        APIService.daoDelegateVotes(delegateId: delegateID, offset: votes.count)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] votes, headers in
                self?.votes.append(contentsOf: votes)
                self?.total = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }
    
    func retryLoadMore() {
        failedToLoadMore = true
    }

    func hasMore() -> Bool {
        guard let total = total else { return true }
        return votes.count < total
    }
}
