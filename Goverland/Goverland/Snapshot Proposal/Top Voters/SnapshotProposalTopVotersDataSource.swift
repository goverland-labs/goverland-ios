//
//  SnapshotProposalTopVotersDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 26.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

class SnapshotProposalTopVotersDataSource: TopVotersDataSource<TopProposalVoter> {
    let proposal: Proposal

    init(proposal: Proposal) {
        self.proposal = proposal
        super.init()
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
                self.totalVotingPower = Utils.getTotalVotingPower(from: headers)
                self.total = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }
}
