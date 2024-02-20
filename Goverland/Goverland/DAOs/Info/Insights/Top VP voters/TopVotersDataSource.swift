//
//  TopVotersDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-07.
//  Copyright © Goverland Inc. All rights reserved.
//
	
import Foundation
import Combine

class TopVotersDataSource: ObservableObject, Refreshable {
    private let daoID: UUID
    @Published var topVotePowerVoters: [TopVoter] = []
    @Published var totalVotingPower: Double?
    @Published var totalVotesCount: Double?
    @Published var failedToLoadInitialData: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    var top10votersGraphData: [TopVoter] {
        var topVoters = topVotePowerVoters
        if let totalPower = totalVotingPower, let totalCount = totalVotesCount {
            topVoters.append(TopVoter(name: Address("Other"),
                                            voterPower: totalPower - getTop10VotersVotingPower(),
                                            voterCount: totalCount - getTop10VotersVotesCount()))
        }
        return topVoters
    }
    
    init(daoID: UUID) {
        self.daoID = daoID
    }
    
    convenience init(dao: Dao) {
        self.init(daoID: dao.id)
    }

    func refresh() {
        topVotePowerVoters = []
        failedToLoadInitialData = false
        cancellables = Set<AnyCancellable>()

        loadInitialData()
    }

    private func loadInitialData() {
        APIService.topVoters(id: daoID, limit: 10)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] result, headers in
                guard let `self` = self else { return }
                self.topVotePowerVoters = result
                self.totalVotingPower = Utils.getTotalVotingPower(from: headers)
                self.totalVotesCount = Utils.getTotalVotesCount(from: headers)
            }
            .store(in: &cancellables)
    }
    
    private func getTop10VotersVotingPower() -> Double {
        return topVotePowerVoters.reduce(0) { $0 + $1.voterPower }
    }
    
    private func getTop10VotersVotesCount() -> Double {
        return topVotePowerVoters.reduce(0) { $0 + $1.voterCount }
    }
}
