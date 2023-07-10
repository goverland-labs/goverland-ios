//
//  ProposalDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-09.
//

import SwiftUI
import Combine

class ProposalDataSource: ObservableObject, Refreshable {
    @Published var proposalsList: [Proposal] = []
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()

    init() {
        refresh()
    }

    func refresh() {
        proposalsList = []
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
                self?.proposalsList = proposals
            }
            .store(in: &cancellables)
    }
}
