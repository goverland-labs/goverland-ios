//
//  PublicUserProfileActivityDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 13.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class PublicUserProfileActivityDataSource: ObservableObject, Refreshable {
    private let address: Address

    @Published var votedProposals: [Proposal]?
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    @Published var total: Int?
    private var cancellables = Set<AnyCancellable>()

    init(address: Address) {
        self.address = address
    }

    func refresh() {
        votedProposals = nil
        failedToLoadInitialData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()

        //loadInitialData()
        self.votedProposals = [.aaveTest, .aaveTest]
        self.total = 2
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
}
