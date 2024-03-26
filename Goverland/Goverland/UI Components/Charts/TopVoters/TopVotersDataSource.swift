//
//   TopVotersDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 26.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class TopVotersDataSource<Voter: VoterVotingPower>: ObservableObject, Refreshable {
    // TODO: make optional. Result can be empty when loading Proposal votes
    @Published var topVoters: [Voter] = []
    @Published var totalVotingPower: Double?
    @Published var failedToLoadInitialData: Bool = false
    var cancellables = Set<AnyCancellable>()

    var total: Int?

    func refresh() {
        topVoters = []
        totalVotingPower = nil
        failedToLoadInitialData = false
        cancellables = Set<AnyCancellable>()

        loadData()
    }

    func loadData() {
        // override
    }

    var top10votersGraphData: [Voter] {
        var topVoters = topVoters
        let total = total ?? 0
        if let totalPower = totalVotingPower, total > 10 {
            let otherUser = User(address: Address("Other"), resolvedName: "Other", avatars: [])
            topVoters.append(
                Voter(
                    voter: otherUser,
                    votingPower: totalPower - getTop10VotersVotingPower()
                )
            )
        }
        return topVoters
    }

    func getTop10VotersVotingPower() -> Double {
        return topVoters.reduce(0) { $0 + $1.votingPower }
    }
}
