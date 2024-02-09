//
//  SnapshotProposalDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 09.02.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class SnapshotProposalDataSource: ObservableObject, Refreshable {
    private let proposalId: String

    @Published var proposal: Proposal?
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()

    init(proposal: Proposal) {
        self.proposalId = proposal.id
        self.proposal = proposal
    }

    func refresh() {
        failedToLoadInitialData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()
        loadInitialData()
    }

    private func loadInitialData() {
        isLoading = true
        APIService.proposal(id: proposalId)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] proposal, _ in
                self?.proposal = proposal
            }
            .store(in: &cancellables)
    }
}
