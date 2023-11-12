//
//  CastYourVoteModel.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//


import Foundation
import Combine

class CastYourVoteModel: ObservableObject {
    let proposal: Proposal
    let choice: AnyObject

    @Published var validated: Bool?

    @Published var isPreparing = false
    @Published var prepared: Bool?

    @Published var votingPower = 0
    @Published var errorMessage: String?
    
    @Published var failedToValidate = false
    @Published var failedToPrepare = false
    
    private var cancellables = Set<AnyCancellable>()

    private let failedToValidateMessage = "Failed to validate. Please try again later. If the problem persists, don't hesitate to contact our team in Discord, and we will try to help you."
    private let failedToPrepareMessage = "Failed to vote. Please try again later. If the problem persists, don't hesitate to contact our team in Discord, and we will try to help you."

    var voter: String {
        // TODO: return from the cached Profile object
        WC_Manager.shared.sessionMeta!.session.accounts.first!.address
    }

    var choiceStr: String {
        switch proposal.type {
        case .singleChoice, .basic:
            return proposal.choices[choice as! Int]

        case .approval:
            let approvedIndices = choice as! [Int]
            let first = proposal.choices[approvedIndices.first!]
            return approvedIndices.dropFirst().reduce(first) { r, i in "\(r), \(proposal.choices[i])" }

        case .rankedChoice:
            let approvedIndices = choice as! [Int]
            let first = proposal.choices[approvedIndices.first!]
            var idx = 1
            return approvedIndices.dropFirst().reduce("(\(idx)) \(first)") { r, i in
                idx += 1
                return "\(r), (\(idx)) \(proposal.choices[i])"
            }

        case .weighted, .quadratic:
            let choicesPower = choice as! [String: Int]
            let totalPower = choicesPower.values.reduce(0, +)

            // to keep them sorted we will use proposal choices array
            let choices = proposal.choices.filter { choicesPower[$0] != 0 }
            let first = choices.first!
            let firstPercentage = Utils.percentage(of: Double(choicesPower[first]!), in: Double(totalPower))
            return choices.dropFirst().reduce("\(firstPercentage) for \(first)") { r, k in
                let percentage = Utils.percentage(of: Double(choicesPower[k]!), in: Double(totalPower))
                return "\(r), \(percentage) for \(k)"
            }
        }
    }

    init(proposal: Proposal, choice: AnyObject) {
        self.proposal = proposal
        self.choice = choice
    }

    private func clear() {
        validated = nil
        votingPower = 0
        errorMessage = nil
        failedToValidate = false
        failedToPrepare = false
        cancellables = Set<AnyCancellable>()
    }

    func validate() {
        clear()
        APIService.validate(proposalID: proposal.id, voter: voter)
            .sink { [weak self] completion in
                guard let `self` = self else { return }
                switch completion {
                case .finished: break
                case .failure(_):
                    self.failedToValidate = true
                    self.errorMessage = self.failedToValidateMessage
                }
            } receiveValue: { [weak self] validation, _ in
                guard let `self` = self else { return }
                switch validation.result {
                case .success(let votingPower):
                    self.validated = true
                    self.votingPower = votingPower
                case .failure(let error):
                    self.validated = false
                    self.errorMessage = error.message
                }
            }
            .store(in: &cancellables)
    }

    func prepareVote() {
        isPreparing = true
        APIService.prepareVote(proposal: proposal, voter: voter, choice: choice, reason: nil)
            .sink { [weak self] completion in
                guard let `self` = self else { return }
                self.isPreparing = false
                switch completion {
                case .finished: break
                case .failure(_):
                    self.failedToPrepare = true
                    self.errorMessage = self.failedToPrepareMessage
                }
            } receiveValue: { [weak self] validation, _ in
                guard let `self` = self else { return }
                switch validation.result {
                case .success(let votingPower):
                    self.prepared = true
                    // TODO: initiate signing process with wallet
                    logInfo("[VOTE] Sucessfully prepared")
                case .failure(let error):
                    self.prepared = false
                    self.errorMessage = error.message
                }
            }
            .store(in: &cancellables)
    }
}
