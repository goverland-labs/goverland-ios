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
    @Published var topVoters: [Voter]?
    @Published var totalVotingPower: Double?
    @Published var failedToLoadInitialData: Bool = false
    var cancellables = Set<AnyCancellable>()

    @Published var selectedFilteringOption: DatesFiltetingOption = .oneYear {
        didSet {
            refresh(invalidateCache: false)
        }
    }

    var total: Int?
    var cache: [DatesFiltetingOption: [Voter]] = [:]

    func refresh() {
        refresh(invalidateCache: true)
    }

    private func refresh(invalidateCache: Bool) {
        if let cachedData = cache[selectedFilteringOption], !invalidateCache {
            topVoters = cachedData
            return
        }

        if invalidateCache {
            cache = [:]
        }

        topVoters = nil
        totalVotingPower = nil
        failedToLoadInitialData = false
        cancellables = Set<AnyCancellable>()

        loadData()
    }

    func loadData() {
        // override
    }

    var top10votersGraphData: [Voter] {
        guard var topVoters = topVoters else { return [] }
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

    var allVotersHaveSamePower: Bool {
        guard let topVoters = topVoters, !topVoters.isEmpty else { return false }
        return topVoters.first!.votingPower == topVoters.last!.votingPower
    }

    private func getTop10VotersVotingPower() -> Double {
        return topVoters!.reduce(0) { $0 + $1.votingPower }
    }
}
