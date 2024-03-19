//
//  PublicUserProfileDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-03-07.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

enum PublicUserProfileFilter: Int, FilterOptions {
    case activity = 0

    var localizedName: String {
        switch self {
        case .activity:
            return "Activity"
        }
    }
}

class PublicUserProfileDataSource: ObservableObject, Refreshable {
    let address: Address
    
    @Published var profile: PublicUserProfile?
    @Published var failedToLoadInitialData = false
    @Published var filter: PublicUserProfileFilter = .activity
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()

    init(address: Address) {
        self.address = address
    }

    func refresh() {
        profile = nil
        failedToLoadInitialData = false
        filter = .activity
        isLoading = false
        cancellables = Set<AnyCancellable>()
        
        //loadInitialData()
        self.profile = PublicUserProfile(
            id: UUID(),
            user: User.aaveChan,
            votedInDaos: [Dao.gnosis, Dao.aave])
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
}
