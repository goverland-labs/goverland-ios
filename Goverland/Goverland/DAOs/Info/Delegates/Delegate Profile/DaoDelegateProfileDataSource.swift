//
//  DaoDelegateProfileDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 13.09.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class DaoDelegateProfileDataSource: ObservableObject, Refreshable {
    private let daoId: String
    private let delegateId: String

    @Published var daoDelegate: DaoDelegate?
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()

    init(daoId: String, delegateId: String) {
        self.daoId = daoId
        self.delegateId = delegateId
    }

    func refresh() {
        daoDelegate = nil
        failedToLoadInitialData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()
        
        loadInitialData()
    }

    private func loadInitialData() {
        isLoading = true
        APIService.daoDelegateProfile(daoId: daoId, delegateId: delegateId)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] daoDelegate, headers in
                self?.daoDelegate = daoDelegate
            }
            .store(in: &cancellables)
    }
}
