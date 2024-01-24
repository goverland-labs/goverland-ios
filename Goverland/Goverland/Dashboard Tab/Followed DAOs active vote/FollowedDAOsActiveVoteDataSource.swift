//
//  FollowedDAOsActiveVoteDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 24.01.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class FollowedDAOsActiveVoteDataSource: ObservableObject, Refreshable {
    @Published var daos: [Dao] = []
    @Published var failedToLoadInitialData: Bool = false
    private var cancellables = Set<AnyCancellable>()

    static let shared = FollowedDAOsActiveVoteDataSource()
    
    private init() {}

    func refresh() {
        daos = []
        failedToLoadInitialData = false
        cancellables = Set<AnyCancellable>()

        loadInitialData()
    }

    private func loadInitialData() {
        guard !SettingKeys.shared.authToken.isEmpty else { return }

        APIService.daosWithActiveVote()
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] result, _ in
                self?.daos = result
            }
            .store(in: &cancellables)
    }
}
