//
//  CastYourVoteDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//


import Foundation
import Combine
import WalletConnectSign

class CastYourVoteDataSource: ObservableObject {
    let proposal: Proposal
    let choice: AnyObject?
    let onSuccess: () -> Void

    @Published var validated: Bool?

    @Published var reason = ""

    @Published var isPreparing = false
    @Published var infoMessage: String?

    @Published var isSubmitting = false
    @Published var submitted = false

    @Published var votingPower = 0
    @Published var errorMessage: String?
    
    @Published var failedToValidate = false

    private var cancellables = Set<AnyCancellable>()

    private let failedToValidateMessage = "Failed to validate. Please try again later. If the problem persists, don't hesitate to contact our team in Discord, and we will try to help you."
    private let failedToVoteMessage = "Failed to vote. Please try again later. If the problem persists, don't hesitate to contact our team in Discord, and we will try to help you."
    private let openWalletMessage = "Please open your wallet to sign the vote."

    private var voteRequestId: UUID?

    var isShieldedVoting: Bool {
        proposal.privacy == .shutter
    }

    var choiceStr: String {
        guard let choice else { return "" }
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
            let choices = proposal.choices.indices.filter { choicesPower[String($0 + 1)] != 0 }
            let first = choices.first!
            let firstPercentage = Utils.percentage(of: Double(choicesPower[String(first + 1)]!), in: Double(totalPower))
            return choices.dropFirst().reduce("\(firstPercentage) for \(first + 1)") { r, k in
                let percentage = Utils.percentage(of: Double(choicesPower[String(k + 1)]!), in: Double(totalPower))
                return "\(r), \(percentage) for \(k + 1)"
            }
        }
    }

    init(proposal: Proposal, choice: AnyObject?, onSuccess: @escaping () -> Void) {
        self.proposal = proposal
        self.choice = choice
        self.onSuccess = onSuccess
        listen_WC_Responses()
    }

    private func clear() {
        validated = nil
        votingPower = 0
        errorMessage = nil
        infoMessage = nil
        failedToValidate = false
        submitted = false
        // do not clear cancellables
    }

    func validate(address: String) {
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

    func prepareVote(address: String) {
        errorMessage = nil
        infoMessage = nil
        isPreparing = true
        voteRequestId = nil

        let normalizedReason = reason.trimmingCharacters(in: .whitespacesAndNewlines)
        let reason = normalizedReason.isEmpty ? nil : normalizedReason

        APIService.prepareVote(proposal: proposal, voter: address, choice: choice!, reason: reason)
            .sink { [weak self] completion in
                guard let `self` = self else { return }
                self.isPreparing = false
                switch completion {
                case .finished: break
                case .failure(_):
                    self.errorMessage = self.failedToVoteMessage
                }
            } receiveValue: { [weak self] prep, _ in
                guard let `self` = self else { return }
                self.voteRequestId = prep.id
                self.signTypedData(prep.typedData, address: address)
            }
            .store(in: &cancellables)
    }

    private func signTypedData(_ typedData: String, address: String) {
        logInfo("[WC] eth_signTypedData(_v4): \(typedData)")
        guard let session = WC_Manager.shared.sessionMeta?.session else { return }
        let params = AnyCodable([address, typedData])

        // TODO: check if all popular wallets support eth_sighTypedData_v4
        let request = Request(
            topic: session.topic,
            method: "eth_signTypedData_v4",
            params: params,
            chainId: Blockchain("eip155:1")!)

        Task {
            try? await Sign.instance.request(params: request)
        }

        if let redirectUrl = WC_Manager.sessionWalletRedirectUrl {
            openUrl(redirectUrl)
        } else {
            infoMessage = openWalletMessage
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
        isSubmitting = true
        guard let voteRequestId else { return }
        APIService.submitVote(proposal: proposal, id: voteRequestId, signature: signature)
            .sink { [weak self] completion in
                guard let `self` = self else { return }
                self.isSubmitting = false
                switch completion {
                case .finished: break
                case .failure(_):
                    self.errorMessage = self.failedToVoteMessage
                }
            } receiveValue: { [weak self] resp, _ in
                logInfo("[VOTE]: Succesfully submitted: \(resp)")
                self?.submitted = true
                self?.onSuccess()
            }
            .store(in: &cancellables)
    }
}
