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

    @Published var votedProposals: [Proposal] = []
    @Published var votedDaos: [Dao]?
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    @Published var total: Int?
    private var cancellables = Set<AnyCancellable>()

    init(address: Address) {
        self.address = address
    }

    func refresh() {
        votedProposals = []
        failedToLoadInitialData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()
        
        loadInitialData()
    }

    private func loadInitialData() {
        isLoading = true
        APIService.getPublicProfileVotes(address: address)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] proposals, headers in
                guard let self else { return }
                self.votedProposals = proposals
                self.total = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    
        APIService.getPublicProfileDaos(address: address)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] daos, headers in
                self?.votedDaos = daos
            }
            .store(in: &cancellables)
    }
    
    func getUserAddress() -> Address {
        return self.address
    }
}
