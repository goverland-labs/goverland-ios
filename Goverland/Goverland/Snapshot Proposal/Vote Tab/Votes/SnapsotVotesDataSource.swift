//
//  SnapsotVotersDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-12.
//

import SwiftUI
import Combine

class SnapsotVotesDataSource: ObservableObject {
    private let proposal: Proposal
    
    @Published var votes: [Vote] = []
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    private var proposalID = UUID()

    init(proposal: Proposal) {
        self.proposal = proposal
        print(proposal.id)
        if let url = UUID(uuidString: proposal.id) {
            self.proposalID = url
        }
        refresh()
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
        APIService.votes(proposalID: proposalID)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] votes, headers in
               print("VOTES: \(votes)")
            }
            .store(in: &cancellables)
    }
}
