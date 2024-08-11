//
//  SnapshotProposalDescriptionViewDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 08.08.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class SnapshotProposalDescriptionViewDataSource: ObservableObject, Refreshable {
    let proposal: Proposal

    @Published var aiDescription: String?
    @Published var isLoading = false
    @Published var descriptionIsExpanded = false
    private var cancellables = Set<AnyCancellable>()

    init(proposal: Proposal) {
        self.proposal = proposal
    }

    func refresh() {
        logInfo("[App] loading proposal ai description")
        aiDescription = nil
        isLoading = false
        descriptionIsExpanded = false
        cancellables = Set<AnyCancellable>()
        load_AI_description()
    }

    func load_AI_description() {
        guard aiDescription == nil else { return }

        // TODO: implement networking
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.isLoading = false
//            self?.aiDescription = "Test description aaa. Test description aaa. Test description aaa. Test description aaa. Test description aaa. Test description aaa. Test description aaa. Test description aaa. Test description aaa. Test description aaa. Test description aaa. Test description aaa. Test description aaa. Test description aaa. Test description aaa. Test description aaa. Test description aaa. Test description aaa. Test description aaa. Test description aaa. Test description aaa. Test description aaa. Test description aaa. Test description aaa."
        }
    }
}
