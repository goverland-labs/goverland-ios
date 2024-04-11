//
//  PublicUserProfileVotesDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 13.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class PublicUserProfileVotesDataSource: ObservableObject, Refreshable {
    let address: Address

    @Published var votedProposals: [Proposal] = []
    @Published var failedToLoadInitialData = false
    @Published var failedToLoadMore = false
    @Published var isLoading = false
    @Published var total: Int?
    private var cancellables = Set<AnyCancellable>()

    init(address: Address) {
        self.address = address
    }

    func refresh() {
        votedProposals = []
        failedToLoadInitialData = false
        failedToLoadMore = false
        isLoading = false
        total = nil
        cancellables = Set<AnyCancellable>()
        
        loadInitialData()
    }

    private func loadInitialData() {
        isLoading = true
        APIService.getPublicProfileVotes(address: address)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] proposals, headers in
                self?.votedProposals = proposals
                self?.total = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }

    func loadMore() {
        APIService.getPublicProfileVotes(address: address, offset: votedProposals.count)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadMore = true
                }
            } receiveValue: { [weak self] proposals, headers in
                guard let `self` = self else { return }
                self.votedProposals.append(contentsOf: proposals)
                self.total = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }

    func retryLoadMore() {
        // This will trigger view update cycle that will trigger `loadMore` function
        self.failedToLoadMore = false
    }
}
