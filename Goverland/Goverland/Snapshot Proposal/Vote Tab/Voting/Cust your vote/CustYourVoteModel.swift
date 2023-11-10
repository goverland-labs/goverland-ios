//
//  CustYourVoteModel.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class CustYourVoteModel: ObservableObject {
    let proposal: Proposal

    @Published var valid: Bool?
    @Published var votingPower = 0
    @Published var errorMessage: String?
    @Published var failedToValidate = false
    private var cancellables = Set<AnyCancellable>()

    var voter: String {
        // TODO: return from the cached Profile object
        WC_Manager.shared.sessionMeta!.session.accounts.first!.address
    }

    init(proposal: Proposal) {
        self.proposal = proposal
    }

    private func clear() {
        valid = nil
        votingPower = 0
        errorMessage = nil
        failedToValidate = false
        cancellables = Set<AnyCancellable>()
    }

    func validate() {
        clear()
        APIService.validate(proposalID: proposal.id, voter: voter)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToValidate = true
                }
            } receiveValue: { [weak self] validation, _ in
                switch validation.result {
                case .success(let votingPower): self?.votingPower = votingPower
                case .failure(let error): self?.errorMessage = error.message
                }
            }
            .store(in: &cancellables)
    }
}
