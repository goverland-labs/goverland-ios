//
//  PublicUserProfileVotesDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 13.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class PublicUserProfileVotesDataSource: ObservableObject, Paginatable, Refreshable {
    let user: User

    @Published var votedProposals: [Proposal]?
    @Published var isLoading = false
    @Published var failedToLoadInitialData = false
    @Published var failedToLoadMore = false
    private var cancellables = Set<AnyCancellable>()

    private(set) var total: Int?

    init(user: User) {
        self.user = user
    }

    func refresh() {
        votedProposals = nil
        isLoading = false
        failedToLoadInitialData = false
        failedToLoadMore = false
        cancellables = Set<AnyCancellable>()
        total = nil
        
        loadInitialData()
    }

    private func loadInitialData() {
        isLoading = true
        APIService.getPublicProfileVotes(address: user.address)
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

    func hasMore() -> Bool {
        guard let votedProposals, let total = total else { return true }
        return votedProposals.count < total
    }

    func loadMore() {
        APIService.getPublicProfileVotes(address: user.address, offset: votedProposals?.count ?? 0)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadMore = true
                }
            } receiveValue: { [weak self] proposals, headers in
                guard let `self` = self else { return }
                self.votedProposals?.append(contentsOf: proposals)
                self.total = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }

    func retryLoadMore() {
        // This will trigger view update cycle that will trigger `loadMore` function
        self.failedToLoadMore = false
    }
}
