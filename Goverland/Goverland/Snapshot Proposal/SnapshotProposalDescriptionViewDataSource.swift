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
    @Published var failedToLoadInitialData = false
    @Published var limitReachedOnSummary = false
    @Published var descriptionIsExpanded = false
    private var cancellables = Set<AnyCancellable>()

    init(proposal: Proposal) {
        self.proposal = proposal
    }

    func refresh() {
        logInfo("[App] loading proposal ai description")
        aiDescription = nil
        isLoading = false
        failedToLoadInitialData = false
        failedToLoadInitialData = false
        descriptionIsExpanded = false
        cancellables = Set<AnyCancellable>()
        load_AI_description()
    }

    func load_AI_description() {
        guard aiDescription == nil else { return }

        isLoading = true
        APIService.proposalSummary(id: proposal.id)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(let apiError):
                    if case .badRequest(_) = apiError {
                        self?.limitReachedOnSummary = true
                    } else {
                        self?.failedToLoadInitialData = true
                    }
                }
            } receiveValue: { [weak self] summary, _ in
                self?.aiDescription = summary.summaryMarkdown + "\n\n###### ⚠️ AI can be inaccurate or misleading\n"      
            }
            .store(in: &cancellables)
    }
}
