//
//  PublicProfileDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-03-07.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

enum PublicProfileFilter: Int, FilterOptions {
    case activity = 0

    var localizedName: String {
        switch self {
        case .activity:
            return "Activity"
        }
    }
}

class PublicProfileDataSource: ObservableObject {
    private let address: Address
    
    @Published var profile: PublicProfile?
    @Published var votes: [Proposal]?
    @Published var failedToLoadInitialData = false
    @Published var failedToLoadIVotesData = false
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()

    init(address: Address) {
        self.address = address
        refresh()
    }

    func refresh() {
        profile = nil
        failedToLoadIVotesData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()
        loadInitialData()
    }
    
    func getVotes() {
        votes = []
        failedToLoadInitialData = false
        getPublicProfileVotes(address: address)
    }

    private func loadInitialData() {
        isLoading = true
        APIService.publicProfile(address: address)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] profile, _ in
                self?.profile = profile
            }
            .store(in: &cancellables)
    }
    
    private func getPublicProfileVotes(address: Address) {
        isLoading = true
        APIService.getPublicProfileVotes(address: address)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadIVotesData = true
                }
            } receiveValue: { [weak self] votes, _ in
                self?.votes = votes
            }
            .store(in: &cancellables)
    }
}
