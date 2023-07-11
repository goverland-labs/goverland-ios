//
//  ProposalDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-09.
//

import SwiftUI
import Combine

class ProposalDataSource: ObservableObject, Refreshable, Paginatable {
    
    @Published var proposals: [Proposal] = []
    @Published var failedToLoadInitialData = false
    @Published var failedToLoadMore = false
    @Published var isLoading = false
    private(set) var totalProposals: Int?
    private(set) var totalSkippedProposals: Int?
    private var cancellables = Set<AnyCancellable>()

    @Published var searchText = ""
    @Published var searchResultProposals: [Proposal] = []
    @Published var nothingFound: Bool = false
    private var searchCancellable: AnyCancellable?

    init() {
        searchCancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.performSearch(searchText)
            }
    }

    func refresh() {
        proposals = []
        failedToLoadInitialData = false
        failedToLoadMore = false
        isLoading = false
        totalProposals = nil
        cancellables = Set<AnyCancellable>()

        loadInitialData()
    }

    private func loadInitialData() {
        isLoading = true
        APIService.proposals()
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] proposals, headers in
                self?.proposals = proposals
                self?.totalProposals = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }
    
    func hasMore() -> Bool {
        guard let total = totalProposals, let totalSkipped = totalSkippedProposals else { return true }
        return proposals.count < total - totalSkipped
    }
    
    func retryLoadMore() {
        // This will trigger view update cycle that will trigger `loadMore` function
        self.failedToLoadMore = false
    }

    func loadMore() {
        APIService.proposals(offset: proposals.count)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadMore = true
                }
            } receiveValue: { [weak self] result, headers in
                self?.failedToLoadMore = false
                self!.proposals.append(contentsOf: result)
                self!.totalProposals = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }

    private func performSearch(_ searchText: String) {
        nothingFound = false
        guard searchText != "" else { return }

        APIService.proposals(query: searchText)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.nothingFound = true
                }
            } receiveValue: { [weak self] proposals, headers in
                self?.nothingFound = proposals.isEmpty
                self?.searchResultProposals = proposals
            }
            .store(in: &cancellables)
    }
}
