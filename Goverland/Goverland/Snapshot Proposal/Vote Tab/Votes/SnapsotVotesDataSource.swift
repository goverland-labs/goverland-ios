//
//  SnapsotVotersDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-12.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import Combine

class SnapsotVotesDataSource<ChoiceType: Decodable>: ObservableObject, Paginatable, Refreshable {
    private let proposal: Proposal
    
    @Published var votes: [Vote<ChoiceType>] = []
    @Published var failedToLoadInitialData = false
    @Published var failedToLoadMore = false
    @Published var isLoading = false
    @Published var searchText = ""
    @Published var searchResultVotes: [Vote<ChoiceType>] = []
    @Published var nothingFound: Bool = false
    
    private(set) var total: Int?
    private var cancellables = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable!
    
    var totalVotes: Int {
        return total ?? 0
    }

    init(proposal: Proposal) {
        self.proposal = proposal
        
        searchCancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.performSearch(searchText)
            }
    }

    func refresh() {
        votes = []
        failedToLoadInitialData = false
        isLoading = false
        searchText = ""
        searchResultVotes = []
        nothingFound = false
        cancellables = Set<AnyCancellable>()
        // do not clear searchCancellable
        
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
            } receiveValue: { [weak self] (votes: [Vote<ChoiceType>], headers) in
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
            } receiveValue: { [weak self] (votes: [Vote<ChoiceType>], headers) in
                self?.failedToLoadMore = false
                self?.votes.append(contentsOf: votes)
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
    
    private func performSearch(_ searchText: String) {
        nothingFound = false
        guard searchText != "" else { return }

        APIService.votes(proposalID: proposal.id, offset: 0, query: searchText)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.nothingFound = true
                }
            } receiveValue: { [weak self] (votes: [Vote<ChoiceType>], headers) in
                self?.nothingFound = false
                self?.searchResultVotes = votes
            }
            .store(in: &cancellables)
    }
}
