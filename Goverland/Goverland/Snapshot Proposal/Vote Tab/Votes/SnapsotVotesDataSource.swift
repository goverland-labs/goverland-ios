//
//  SnapsotVotersDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-12.
//

import SwiftUI
import Combine

class SnapsotVotesDataSource: ObservableObject, Paginatable, Refreshable {
    private let proposal: Proposal
    
    @Published var votes: [Vote] = []
    @Published var failedToLoadInitialData = false
    @Published var failedToLoadMore = false
    @Published var isLoading = false
    private(set) var total: Int?
    private var cancellables = Set<AnyCancellable>()
    
    var totalVotes: Int {
        return total ?? 0
    }

    init(proposal: Proposal) {
        self.proposal = proposal
    }

    func refresh() {
        votes = []
        failedToLoadInitialData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()
        
        loadInitialData()
    }

    private func loadInitialData() {
        isLoading = true
        APIService.votes(proposalID: proposal.id)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] votes, headers in
                self?.votes = votes
                self?.total = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }
    
    func loadMore() {
        APIService.votes(proposalID: proposal.id, offset: votes.count)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadMore = true
                }
            } receiveValue: { [weak self] result, headers in
                self?.failedToLoadMore = false
                self?.votes.append(contentsOf: result)
                self?.total = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }
    
    func retryLoadMore() {
        // This will trigger view update cycle that will trigger `loadMore` function
        self.failedToLoadMore = false
    }

    func hasMore() -> Bool {
        guard let total = total else { return true }
        return votes.count < total
    }
}
