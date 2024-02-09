//
//  SnapshotProposalDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 09.02.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class SnapshotProposalDataSource: ObservableObject, Refreshable {
    private let proposalId: String

    @Published var proposal: Proposal?
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()

    init(proposal: Proposal) {
        self.proposalId = proposal.id
        self.proposal = proposal
    }

    func refresh() {
        
    }
}
