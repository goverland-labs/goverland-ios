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
    var total: Int?

    @Published var failedToLoadInitialData: Bool = false
    var cancellables = Set<AnyCancellable>()

    var selectedFilteringOption: DatesFiltetingOption {
        didSet {
            refresh(invalidateCache: false)
        }
    }


    var cache: [DatesFiltetingOption: [Voter]] = [:]
    var cacheTotalVP: [DatesFiltetingOption: Double] = [:]
    var cacheTotal: [DatesFiltetingOption: Int] = [:]

    init(selectedFilteringOption: DatesFiltetingOption) {
        self.selectedFilteringOption = selectedFilteringOption
    }

    func refresh() {
        refresh(invalidateCache: true)
    }

    private func refresh(invalidateCache: Bool) {
        if let cachedVoters = cache[selectedFilteringOption], 
            let cachedTotalVP = cacheTotalVP[selectedFilteringOption],
            let cacheTotal = cacheTotal[selectedFilteringOption],
            !invalidateCache
        {
            topVoters = cachedVoters
            totalVotingPower = cachedTotalVP
            total = cacheTotal
            return
        }

        if invalidateCache {
            cache = [:]
            cacheTotalVP = [:]
            cacheTotal = [:]
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
