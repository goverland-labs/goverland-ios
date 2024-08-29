//
//  PublicUserProfileDaosDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 05.04.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class PublicUserProfileDaosDataSource: ObservableObject, Refreshable {
    let profileId: String

    @Published var daos: [Dao] = []
    @Published var failedToLoadInitialData = false
    @Published var isLoading: Bool = true
    private var cancellables = Set<AnyCancellable>()

    init(profileId: String) {
        self.profileId = profileId
    }

    func refresh() {
        daos = []
        isLoading = false
        failedToLoadInitialData = false
        cancellables = Set<AnyCancellable>()
        loadData()
    }

    private func loadData() {
        isLoading = true
        APIService.getPublicProfileDaos(profileId: profileId)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] daos, headers in
                self?.daos = daos
            }
            .store(in: &cancellables)
    }
}
