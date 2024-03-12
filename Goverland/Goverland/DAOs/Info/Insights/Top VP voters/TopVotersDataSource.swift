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
    @Published var topVoters: [TopVoter] = []
    @Published var totalVotingPower: Double?
    @Published var failedToLoadInitialData: Bool = false
    private var cancellables = Set<AnyCancellable>()

    private var total: Int?

    var top10votersGraphData: [TopVoter] {
        var topVoters = topVoters
        let total = total ?? 0
        if let totalPower = totalVotingPower, total > 10 {
            topVoters.append(TopVoter(name: Address("Other"),
                                      votingPower: totalPower - getTop10VotersVotingPower(),
                                      votesCount: 0))
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
        topVoters = []
        totalVotingPower = nil
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
                self.topVoters = result
                self.totalVotingPower = Utils.getTotalVotingPower(from: headers)
                self.total = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }

    private func getTop10VotersVotingPower() -> Double {
        return topVoters.reduce(0) { $0 + $1.votingPower }
    }
}
