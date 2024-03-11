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
import CoinbaseWalletSDK

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

    @Published var votingPower: Double = 0.0
    @Published var errorMessage: String?
    
    @Published var failedToValidate = false

    private var cancellables = Set<AnyCancellable>()

    private let failedToValidateMessage = "Failed to validate. Please try again later. If the problem persists, don't hesitate to contact our team in Discord, and we will try to help you."
    private let failedToVoteMessage = "Failed to vote. Please try again later. If the problem persists, don't hesitate to contact our team in Discord, and we will try to help you."
    private let openWalletMessage = "Please open your wallet to sign the vote"

    private var voteRequestId: UUID?
    private var wcRequestId: Int64?

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
        wcRequestId = nil

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
        if let account = CoinbaseWalletManager.shared.account, account.address.lowercased() == address.lowercased() {
            signTypedData_CoinbaseWallet(typedData, address: address)
        } else if let session = WC_Manager.shared.sessionMeta?.session {
            signTypedData_WC(typedData, address: address, topic: session.topic)
        } else {
            logInfo("[App] No wallet connected to sign typed data")
        }
    }

    private func signTypedData_CoinbaseWallet(_ typedData: String, address: String) {
        logInfo("[CoinbaseWallet] eth_signTypedData(_v4): \(typedData)")

        CoinbaseWalletSDK.shared.makeRequest(
            Request(actions: [
                Action(
                    jsonRpc: .eth_signTypedData_v4(
                        address: address,
                        typedDataJson: JSONString(rawValue: typedData)!
                    )
                )
            ])
        ) { [weak self] result in
            switch result {
            case .success(let message):
                logInfo("[CoinbaseWallet] Signing vote response: \(message)")

                guard let result = message.content.first else {
                    logInfo("[CoinbaseWallet] Did not get any result for vote signing")
                    return
                }

                switch result {
                case .success(let signature_JSONString):
                    let signature = signature_JSONString.description.replacingOccurrences(of: "\"", with: "")
                    logInfo("[CoinbaseWallet] Vote signature: \(signature)")
                    self?.submiteVote(signature: signature)

                case .failure(let actionError):
                    logInfo("[CoinbaseWallet] Signing vote action error: \(actionError)")
                    showToast(actionError.message)
                }

            case .failure(let error):
                logInfo("[CoinbaseWallet] Signing vote error: \(error)")
                CoinbaseWalletManager.disconnect()
                showToast("Please reconnect Coinbase Wallet")
            }
        }
    }

    private func signTypedData_WC(_ typedData: String, address: String, topic: String) {
        logInfo("[WC] eth_signTypedData(_v4): \(typedData)")

        let params = AnyCodable([address, typedData])
        let request = try! Request(
            topic: topic,
            method: "eth_signTypedData_v4",
            params: params,
            chainId: Blockchain("eip155:1")!)

        self.wcRequestId = request.id.integer

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
                guard let self = `self` else { return }

                guard response.id.integer == self.wcRequestId else {
                    // Might happen when a user sends request twice, but wallet signs the first message
                    // that is already invalidated.
                    logInfo("[WC] Response id doesn't match expected id")
                    showToast("The app received a signature for an invalidated request. Please sign the latest message.")
                    return
                }

                logInfo("[WC] Vote signing response: \(response)")

                switch response.result {
                case .error(let rpcError):
                    logInfo("[WC] Vote signing error: \(rpcError)")
                    showLocalNotification(title: "Rejected to sign", body: "Open the App to repeat the request")
                    showToast(rpcError.localizedDescription)
                case .response(let signature):
                    // signature here is AnyCodable
                    guard let signatureStr = signature.value as? String else {
                        logError(GError.appInconsistency(reason: "Expected vote signature as string. Got \(signature)"))
                        return
                    }
                    logInfo("[WC] Vote signature: \(signatureStr)")
                    showLocalNotification(title: "Signature response received", body: "Open the App to proceed")
                    self.submiteVote(signature: signatureStr)
                }
            }
            .store(in: &cancellables)
    }

    private func submiteVote(signature: String) {
        isSubmitting = true
        guard let voteRequestId else { return }
        APIService.submitVote(id: voteRequestId, signature: signature)
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
