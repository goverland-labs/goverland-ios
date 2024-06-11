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
    private let daoID: UUID

    @Published var delegates: [Delegate] = []
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()

    init(dao: Dao) {
        self.daoID = dao.id
    }

    func refresh() {
        delegates = []
        failedToLoadInitialData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()
        
        loadTestData()
//        loadInitialData()
    }

    private func loadInitialData() {
        isLoading = true
        APIService.daoDelegates(daoID: daoID)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] delegates, headers in
                self?.delegates = delegates
            }
            .store(in: &cancellables)
    }

    // TODO: delete
    private func loadTestData() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.isLoading = false
//            self?.failedToLoadInitialData = true
//            self?.delegates = []
            self?.delegates = [
                .init(id: UUID(), user: .aaveChan, about: "test about", statement: "test statement"),
                .init(id: UUID(), user: .flipside, about: "test about", statement: "test statement"),
                .init(id: UUID(), user: .test, about: "test about", statement: "test statement")
            ]
        }
    }
}
