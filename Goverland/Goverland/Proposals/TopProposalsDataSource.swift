//
//  ProposalDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-09.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import Combine

class TopProposalsDataSource: ObservableObject, Refreshable, Paginatable {
    @Published var proposals: [Proposal] = []
    @Published var failedToLoadInitialData = false
    @Published var failedToLoadMore = false
    @Published var isLoading = false

    private(set) var totalProposals: Int?
    private var cancellables = Set<AnyCancellable>()

    static let search = TopProposalsDataSource()
    static let dashboard = TopProposalsDataSource()

    private init() {}

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
        APIService.topProposals()
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
        guard let total = totalProposals else { return true }
        return proposals.count < total
    }
    
    func retryLoadMore() {
        // This will trigger view update cycle that will trigger `loadMore` function
        self.failedToLoadMore = false
    }

    func loadMore() {
        APIService.topProposals(offset: proposals.count)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadMore = true
                }
            } receiveValue: { [weak self] result, headers in
                guard let `self` = self else { return }
                self.failedToLoadMore = false
                self.proposals.append(contentsOf: result)
                self.totalProposals = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }
}
