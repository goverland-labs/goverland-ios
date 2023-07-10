//
//  ProposalDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-09.
//

import SwiftUI
import Combine

class ProposalDataSource: ObservableObject, Refreshable {
    @Published var proposals: [Proposal] = []
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()

    func refresh() {
        proposals = []
        failedToLoadInitialData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()
        
        loadInitialData()
    }

    private func loadInitialData() {
        isLoading = true
        APIService.proposalsList()
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] proposals, headers in
                self?.proposals = proposals
            }
            .store(in: &cancellables)
    }
}
