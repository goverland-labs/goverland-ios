//
//  SnapshotProposalTopVotersDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 26.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

// TODO: move to separate file
struct TopProposalVoter: VoterVotingPower, Decodable {
    let voter: User
    let votingPower: Double

    var id: String {
        voter.address.description
    }

    enum CodingKeys: String, CodingKey {
        case voter
        case votingPower = "vp"
    }
}

class SnapshotProposalTopVotersDataSource: TopVotersDataSource<TopProposalVoter> {
    private let proposal: Proposal

    init(proposal: Proposal) {
        self.proposal = proposal
    }

    override func loadData() {
        APIService.topProposalVotes(proposalId: proposal.id)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] result, headers in
                guard let `self` = self else { return }
                // filter the first voter out if this is the app user
                let filtered = result.sorted { $0.votingPower > $1.votingPower }.prefix(10)
                self.topVoters = Array(filtered)
                self.cache[selectedFilteringOption] = Array(filtered)
                self.totalVotingPower = Utils.getTotalVotingPower(from: headers)
                self.total = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }
}
