//
//  ProfileHasVotingPowerDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 25.01.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class ProfileHasVotingPowerDataSource: ObservableObject, Refreshable {
    @Published var proposals: [Proposal]?
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()

    static let dashboard = ProfileHasVotingPowerDataSource()

    private init() {}

    func refresh() {
        proposals = nil
        failedToLoadInitialData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()

        loadInitialData()
    }

    private func loadInitialData() {
        guard !SettingKeys.shared.authToken.isEmpty else { return }
        
        isLoading = true
        APIService.profileHasVotingPower()
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
