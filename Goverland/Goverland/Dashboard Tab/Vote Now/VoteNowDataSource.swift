//
//  VoteNowDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-09-23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class VoteNowDataSource: ObservableObject, Refreshable {
    @Published var proposals: [Proposal]?
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()

    static let dashboard = VoteNowDataSource()

    private init() {}

    func refresh() {
        proposals = nil
        failedToLoadInitialData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()

        //loadInitialData()
        loadMockData()
    }
    
    func loadFullList() {
        proposals = nil
        failedToLoadInitialData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()

        //loadInitialData()
        loadMockData()
    }
    
    private func loadMockData() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.proposals = [.aaveTest, .aaveTest]
            self.isLoading = false
        }
    }

    private func loadInitialData() {
        guard !SettingKeys.shared.authToken.isEmpty else { return }
        
        isLoading = true
        APIService.voteNowProposals()
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
    
    private func loadFullData() {
        guard !SettingKeys.shared.authToken.isEmpty else { return }
        
        isLoading = true
        APIService.voteNowProposals(value: true)
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

