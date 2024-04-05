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
    let address: Address

    @Published var daos: [Dao] = []
    @Published var failedToLoadInitialData = false
    @Published var isLoading: Bool = true
    private var cancellables = Set<AnyCancellable>()

    init(address: Address) {
        self.address = address
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
        APIService.getPublicProfileDaos(address: address)
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
