//
//  TopVotePowerVotersDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-07.
//  Copyright © Goverland Inc. All rights reserved.
//
	
import Foundation
import Combine

class TopVotePowerVotersDataSource: ObservableObject, Refreshable {
    private let daoID: UUID
    @Published var topVotePowerVoters: [VotePowerVoter]?
    @Published var failedToLoadInitialData: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init(daoID: UUID) {
        self.daoID = daoID
    }
    
    convenience init(dao: Dao) {
        self.init(daoID: dao.id)
    }

    func refresh() {
        topVotePowerVoters = nil
        failedToLoadInitialData = false
        cancellables = Set<AnyCancellable>()

        loadInitialData()
    }

    private func loadInitialData() {
        APIService.topVotePowerVoters(id: daoID)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] result, _ in
                print(result)
                self?.topVotePowerVoters = result
            }
            .store(in: &cancellables)
    }
}
