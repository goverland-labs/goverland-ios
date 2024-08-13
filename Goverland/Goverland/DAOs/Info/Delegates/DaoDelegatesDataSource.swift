//
//  DaoDelegatesDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 11.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class DaoDelegatesDataSource: ObservableObject, Refreshable {
    let dao: Dao

    @Published var delegates: [Delegate] = []
    @Published var total: Int?
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()

    init(dao: Dao) {
        self.dao = dao
    }

    func refresh() {
        delegates = []
        total = nil
        failedToLoadInitialData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()
        
        loadTestData()
//        loadInitialData()
    }

    private func loadInitialData() {
        isLoading = true
        APIService.daoDelegates(daoID: dao.id)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] delegates, headers in
                self?.delegates = delegates
                self?.total = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }

    // TODO: delete when API ready
    private func loadTestData() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.isLoading = false
            self?.delegates = [.delegateAaveChan, .delegateNoDelegated]
            self?.total = 15222
        }
    }
}
