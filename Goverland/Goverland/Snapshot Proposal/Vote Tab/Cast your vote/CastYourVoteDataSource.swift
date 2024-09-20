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

    /// Int64 is WalletConnect request Id, UUID is our backend prep id
    private var requestIds = [Int64: UUID]()

    var isShieldedVoting: Bool {
        proposal.privacy == .shutter
    }

    var choiceStr: String {
        guard let choice else { return "" }
        return Utils.choiseAsStr(proposal: proposal, choice: choice)
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
        requestIds = [:]

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
                self?.signTypedData(prep.typedData, address: address, prepId: prep.id)
            }
            .store(in: &cancellables)
    }

    private func signTypedData(_ typedData: String, address: String, prepId: UUID) {
        if let account = CoinbaseWalletManager.shared.account, account.address.lowercased() == address.lowercased() {
            signTypedData_CoinbaseWallet(typedData, address: address, prepId: prepId)
        } else if let session = WC_Manager.shared.sessionMeta?.session {
            signTypedData_WC(typedData, address: address, topic: session.topic, prepId: prepId)
        } else {
            logInfo("[App] No wallet connected to sign typed data")
        }
    }

    private func signTypedData_CoinbaseWallet(_ typedData: String, address: String, prepId: UUID) {
        logInfo("[CoinbaseWallet] eth_signTypedData_v4: \(typedData)")

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
                    self?.submiteVote(signature: signature, prepId: prepId)

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

    private func signTypedData_WC(_ typedData: String, address: String, topic: String, prepId: UUID) {
        logInfo("[WC] eth_signTypedData_v4): \(typedData)")

        let params = AnyCodable([address, typedData])
        let request = try! Request(
            topic: topic,
            method: "eth_signTypedData_v4",
            params: params,
            chainId: Blockchain("eip155:1")!)

        self.requestIds[request.id.integer] = prepId

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

                guard let prepId = requestIds[response.id.integer] else {
                    logInfo("[WC] Response id doesn't match expected id")
                    showToast("The app received a signature for an invalidated request. Please sign the latest message.")
                    return
                }

                logInfo("[WC] Vote signing response: \(response)")

                switch response.result {
                case .error(let rpcError):
                    logInfo("[WC] Vote signing error: \(rpcError)")
                    showLocalNotification(title: "Rejected to sign", body: "Open the App to repeat the request")
                    showToast("Rejected to sign")
                case .response(let signature):
                    // signature here is AnyCodable
                    guard let signatureStr = signature.value as? String else {
                        logError(GError.appInconsistency(reason: "Expected vote signature as string. Got \(signature)"))
                        return
                    }
                    logInfo("[WC] Vote signature: \(signatureStr)")
                    showLocalNotification(title: "Signature response received", body: "Open the App to proceed")
                    self.submiteVote(signature: signatureStr, prepId: prepId)
                }
            }
            .store(in: &cancellables)
    }

    private func submiteVote(signature: String, prepId: UUID) {
        isSubmitting = true
        APIService.submitVote(id: prepId, signature: signature)
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
                guard let self else { return }
                self.submitted = true
                self.onSuccess()
                NotificationCenter.default.post(name: .voteCasted, object: self.proposal)
            }
            .store(in: &cancellables)
    }
}
