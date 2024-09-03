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

    private var cancellables = Set<AnyCancellable>()
    private var wcCancellables = Set<AnyCancellable>()

    var isEnoughBalance: Bool {
        guard let selectedChain else { return false }
        return selectedChain.balance >= selectedChain.feeApproximation
    }

    var chainIsApprovedByWallet: Bool {
        guard let selectedChain else { return false }

        if let cbAddress { return true } // no need to check for Coinbase wallet
        
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
        let request = DaoUserDelegationRequest(chainId: selectedChain.id,
                                               delegates: splitModel.requestDelegates,
                                               expirationDate: expirationDate)

        isPreparingRequest = true
        APIService.daoPrepareSplitDelegation(daoId: dao.id, request: request)
            .sink { [weak self] _ in
                self?.isPreparingRequest = false
            } receiveValue: { [weak self] preparedData, _ in
                logInfo("[App] prepared data: \(preparedData)")
                self?.sendTxWithWallet(preparedData: preparedData)
            }
            .store(in: &cancellables)
    }

    func handleDelegationTxId(txId: String) {
        // TODO: implement logic
        // 1. send success-delegated to backend
        // 2. show monitoring view (replace current with new)
        logInfo("[App] Handle txId: \(txId)")
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
                    self?.handleDelegationTxId(txId: txIdStr)
                }
            }
            .store(in: &wcCancellables)
    }

    private func sendTxWithWallet(preparedData: DaoUserDelegationPreparedData) {
        // TODO: show into to open wallet
//        infoMessage = nil

        if wcAddress != nil {
            wcSendDelegateRequest(preparedData: preparedData)
        } else if cbAddress != nil {
            cbSendDelegateRequest(preparedData: preparedData)
        }
    }

    // TODO: fix, don't work yet
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
                // TODO: implement warning message
//                DispatchQueue.main.async {
//                    self.infoMessage = "Please open your wallet to sign in"
//                }
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
                        maxFeePerGas: nil,
                        maxPriorityFeePerGas: nil,
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
                    self?.handleDelegationTxId(txId: txId)
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
