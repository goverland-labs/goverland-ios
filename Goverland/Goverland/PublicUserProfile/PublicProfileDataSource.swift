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
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()

    init(address: Address) {
        self.address = address
        refresh()
    }

    func refresh() {
        failedToLoadInitialData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()
        loadInitialData()
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
            } receiveValue: { [weak self] profile, header in
                self?.profile = profile
            }
            .store(in: &cancellables)
    }
}
