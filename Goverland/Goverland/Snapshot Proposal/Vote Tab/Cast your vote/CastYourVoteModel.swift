//
//  CastYourVoteModel.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//


import Foundation
import Combine
import WalletConnectSign

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

    var address: String {
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
        listen_WC_Responses()
    }

    private func clear() {
        validated = nil
        votingPower = 0
        errorMessage = nil
        failedToValidate = false
        failedToPrepare = false
        // do not clear cancellables
    }

    func validate() {
        clear()
        APIService.validate(proposalID: proposal.id, voter: address)
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
        APIService.prepareVote(proposal: proposal, voter: address, choice: choice, reason: nil)
            .sink { [weak self] completion in
                guard let `self` = self else { return }
                self.isPreparing = false
                switch completion {
                case .finished: break
                case .failure(_):
                    self.failedToPrepare = true
                    self.errorMessage = self.failedToPrepareMessage
                }
            } receiveValue: { [weak self] prep, _ in
                guard let `self` = self else { return }
                self.signTypedData(prep.typedData)
            }
            .store(in: &cancellables)
    }

    private func signTypedData(_ typedData: String) {
        logInfo("[WC] eth_signTypedData: \(typedData)")
        guard let session = WC_Manager.shared.sessionMeta?.session else { return }
        let params = AnyCodable([address, typedData])

        let request = Request(
            topic: session.topic,
            method: "eth_signTypedData",
            params: params,
            chainId: Blockchain("eip155:1")!)

        Task {
            try? await Sign.instance.request(params: request)
        }

        // TODO: code duplicate. Move to Utils
        if let meta = WC_Manager.shared.sessionMeta, meta.walletOnSameDevice,
           let redirectUrlStr = meta.session.peer.redirect?.universal,
           let redirectUrl = URL(string: redirectUrlStr) {
            openUrl(redirectUrl)
        }
    }

    private func listen_WC_Responses() {
        Sign.instance.sessionResponsePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                logInfo("[WC] Response: \(response)")
                switch response.result {
                case .error(let rpcError):
                    logInfo("[WC] Error: \(rpcError)")
                    showToast(rpcError.localizedDescription)
                case .response(let signature):
                    // signature here is AnyCodable
                    guard let signatureStr = signature.value as? String else {
                        logError(GError.appInconsistency(reason: "Expected signature as string. Got \(signature)"))
                        return
                    }
                    logInfo("[WC] Signature: \(signatureStr)")
                    self?.submiteVote(signature: signatureStr)
                }
            }
            .store(in: &cancellables)
    }

    private func submiteVote(signature: String) {
        // TODO: isSubmitting
        APIService.submitVote(proposal: proposal, voter: address, choice: choice, reason: nil, signature: signature)
            .sink { [weak self] completion in
                guard let `self` = self else { return }
                switch completion {
                case .finished: break
                case .failure(_):
                    break
                    // TODO: impl
//                    self.failedToPrepare = true
//                    self.errorMessage = self.failedToPrepareMessage
                }
            } receiveValue: { [weak self] resp, _ in
                guard let `self` = self else { return }
                logInfo("RESPONSE: \(resp)")
            }
            .store(in: &cancellables)
    }
}
