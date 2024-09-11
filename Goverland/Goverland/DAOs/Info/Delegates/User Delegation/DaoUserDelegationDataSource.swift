//
//  DaoUserDelegationDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-07-23.
//  Copyright © Goverland Inc. All rights reserved.
//


import Foundation
import Combine
import SwiftDate
import WalletConnectSign
import CoinbaseWalletSDK

class DaoUserDelegationDataSource: ObservableObject, Refreshable {
    let dao: Dao
    let delegate: User

    @Published var userDelegation: DaoUserDelegation?
    @Published var selectedChain: Chain?
    @Published var expirationDate: Date?

    @Published var failedToLoadInitialData = false
    @Published var filter: DaoDelegateProfileFilter = .activity
    @Published var isLoading = false
    @Published var isPreparingRequest = false
    @Published var infoMessage: String?

    @Published var txId: String?

    private var cancellables = Set<AnyCancellable>()
    private var wcCancellables = Set<AnyCancellable>()

    private var delegationRequest: DaoUserDelegationRequest?

    var isEnoughBalance: Bool {
        guard let selectedChain else { return false }
        return selectedChain.balance >= selectedChain.feeApproximation
    }

    var chainIsApprovedByWallet: Bool {
        guard let selectedChain else { return false }

        if cbAddress != nil { return true } // no need to check for Coinbase wallet

        guard let wcSession = WC_Manager.shared.sessionMeta?.session,
              let chains = wcSession.namespaces["eip155"]?.chains else {
            return false
        }
        // Wallets approve available blockchains for every session
        return chains.contains { c in
            c.reference == String(selectedChain.id)
        }
    }

    var deltaBalance: Double {
        guard let selectedChain else { return 0.0 }
        return selectedChain.feeApproximation - selectedChain.balance
    }

    private var wcAddress: String? {
        WC_Manager.shared.sessionMeta?.session.accounts.first?.address.lowercased()
    }

    private var cbAddress: String? {
        CoinbaseWalletManager.shared.account?.address.lowercased()
    }

    init(dao: Dao, delegate: User) {
        self.dao = dao
        self.delegate = delegate
        listen_WC_Responses()
    }

    func refresh() {
        userDelegation = nil
        failedToLoadInitialData = false
        filter = .activity
        isLoading = false
        isPreparingRequest = false
        infoMessage = nil
        txId = nil
        delegationRequest = nil

        cancellables = Set<AnyCancellable>()
        // do not reset wcCancellables

        loadData()
    }

    private func loadData() {
        isLoading = true
        APIService.daoUserDelegation(daoID: dao.id)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] userDelegation, _ in
                self?.userDelegation = userDelegation
                self?.assignPreferredChain()
            }
            .store(in: &cancellables)
    }

    private func assignPreferredChain() {
        guard let userDelegation else { return }

        let xdaiBalance = userDelegation.chains.gnosis.balance
        let xdaiFee = userDelegation.chains.gnosis.feeApproximation
        let ethBalance = userDelegation.chains.eth.balance
        let ethFee = userDelegation.chains.eth.feeApproximation

        if xdaiFee <= xdaiBalance {
            self.selectedChain = userDelegation.chains.gnosis
        } else if ethFee <= ethBalance {
            self.selectedChain = userDelegation.chains.eth
        } else {
            self.selectedChain = userDelegation.chains.gnosis
        }
    }

    func prepareSplitDelegation(splitModel: UserDelegationSplitViewModel) {
        guard let selectedChain else { return }
        delegationRequest = DaoUserDelegationRequest(chainId: selectedChain.id,
                                                     txHash: nil,
                                                     delegates: splitModel.requestDelegates,
                                                     expirationDate: expirationDate)

        isPreparingRequest = true
        APIService.daoPrepareSplitDelegation(daoId: dao.id, request: delegationRequest!)
            .sink { [weak self] _ in
                self?.isPreparingRequest = false
            } receiveValue: { [weak self] preparedData, _ in
                logInfo("[App] prepared data: \(preparedData)")
                self?.sendTxWithWallet(preparedData: preparedData)
            }
            .store(in: &cancellables)
    }

    func handleTxId(_ txId: String) {
        self.txId = txId

        // notify backend about transaction for caching
        guard let delegationRequest else { return }
        let request = delegationRequest.with(txHash: txId)
        APIService.daoSuccessDelegated(daoId: dao.id, request: request)
            .sink { _ in
                // do nothing
            } receiveValue: { _, _ in
                logInfo("[App] notified backend about tx_hash")
            }
            .store(in: &cancellables)
    }

    private func listen_WC_Responses() {
        Sign.instance.sessionResponsePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                logInfo("[WC] Response: \(response)")
                switch response.result {
                case .error(let rpcError):
                    logInfo("[WC] Error: \(rpcError)")
                    showLocalNotification(title: "Rejected to send transaction", body: "Open the App to repeat the request")
                    showToast(rpcError.localizedDescription)
                case .response(let txId):
                    guard let txIdStr = txId.value as? String else {
                        logError(GError.appInconsistency(reason: "Expected txId as string. Got \(txId)"))
                        return
                    }
                    logInfo("[WC] txId: \(txIdStr)")
                    showLocalNotification(title: "Transaction is sent", body: "Open the App to proceed")
                    self?.handleTxId(txIdStr)
                }
            }
            .store(in: &wcCancellables)
    }

    private func sendTxWithWallet(preparedData: DaoUserDelegationPreparedData) {
        infoMessage = nil

        if wcAddress != nil {
            wcSendDelegateRequest(preparedData: preparedData)
        } else if cbAddress != nil {
            cbSendDelegateRequest(preparedData: preparedData)
        }
    }

    private func wcSendDelegateRequest(preparedData: DaoUserDelegationPreparedData) {
        guard let session = WC_Manager.shared.sessionMeta?.session,
              let address = wcAddress,
              let chainId = selectedChain?.id else { return }

        let tx = Transaction.from(address, preparedDeleagtionData: preparedData)

        let request = try! Request(
            topic: session.topic,
            method: "eth_sendTransaction",
            params: AnyCodable([tx]),
            chainId: Blockchain("eip155:\(chainId)")!)

        Task {
            try? await Sign.instance.request(params: request)

            if let redirectUrl = WC_Manager.sessionWalletRedirectUrl {
                openUrl(redirectUrl)
            } else {
                DispatchQueue.main.async {
                    self.infoMessage = "Please open your wallet to continue"
                }
            }
        }
    }

    private func cbSendDelegateRequest(preparedData: DaoUserDelegationPreparedData) {
        guard let address = cbAddress, let chainId = selectedChain?.id else { return }

        CoinbaseWalletSDK.shared.makeRequest(
            Request(actions: [
                Action(
                    jsonRpc: .eth_sendTransaction(
                        fromAddress: address,
                        toAddress: preparedData.to,
                        weiValue: "0",
                        data: preparedData.data,
                        nonce: nil,
                        gasPriceInWei: preparedData.gasPrice,
                        maxFeePerGas: preparedData.maxFeePerGas,
                        maxPriorityFeePerGas: preparedData.maxPriorityFeePerGas,
                        gasLimit: preparedData.gas,
                        chainId: "\(chainId)")
                )
            ])
        ) { [weak self] result in
            switch result {
            case .success(let message):
                logInfo("[CoinbaseWallet] Response: \(message)")

                guard let result = message.content.first else {
                    logInfo("[CoinbaseWallet] Did not get any result for sending tx")
                    return
                }

                switch result {
                case .success(let txId_JSONString):
                    let txId = txId_JSONString.description.replacingOccurrences(of: "\"", with: "")
                    logInfo("[CoinbaseWallet] Delegation txId: \(txId)")
                    self?.handleTxId(txId)
                case .failure(let actionError):
                    logInfo("[CoinbaseWallet] Send tx action error: \(actionError)")
                    showToast(actionError.message)
                }

            case .failure(let error):
                logInfo("[CoinbaseWallet] Delegation tx error: \(error)")
                CoinbaseWalletManager.disconnect()
                showToast("Please reconnect Coinbase Wallet")
            }
        }
    }
}
