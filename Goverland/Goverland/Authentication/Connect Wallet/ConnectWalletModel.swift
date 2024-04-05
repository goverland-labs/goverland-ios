//
//  ConnectWalletModel.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 30.08.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation
import Combine
import WalletConnectModal
import CoinbaseWalletSDK

class ConnectWalletModel: ObservableObject {
    @Published private(set) var connecting = false
    @Published private(set) var qrDisplayed = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        listen_WC()
    }

    func showQR() {
        qrDisplayed = true
    }

    func hideQR() {
        qrDisplayed = false
    }

    func connect(wallet: Wallet) {
        connecting = true
        if wallet == .coinbase {
            Tracker.track(.initiateRecommendedWltConnection, parameters: ["wallet" : "Coinbase Wallet"])
            CoinbaseWalletSDK.shared.initiateHandshake(
                initialActions: [
                    Action(jsonRpc: .eth_requestAccounts)
                ]
            ) { result, account in
                switch result {
                case .success(let response):
                    logInfo("[CoinbaseWallet] Response: \(response)")
                    guard let account = account else { return }
                    logInfo("[CoinbaseWallet] Account: \(account)")
                    CoinbaseWalletManager.shared.account = account
                    Tracker.track(.walletConnected, parameters: ["wallet" : "Coinbase Wallet"])
                case .failure(let error):
                    logInfo("[CoinbaseWallet] Error: \(error)")
                    showToast("Connection request denied")
                }
            }
        } else {
            Tracker.track(.initiateRecommendedWltConnection, parameters: ["wallet" : wallet.name])
            Task {
                do {
                    guard let wcUri = try await WalletConnectModal.instance.connect(topic: nil),
                          let url = URL(string: "\(wallet.link)/wc?uri=\(wcUri.deeplinkUri)")
                    else {
                        return
                    }
                    logInfo("[WC] URI: \(String(describing: wcUri))")
                    openUrl(url)
                } catch {
                    showToast("Failed to connect. Please try again later.")
                }
            }
        }
        connecting = false
    }

    private func listen_WC() {
        Sign.instance.sessionSettlePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] session in
                guard let `self` = self else { return }
                logInfo("[WC] Session settle: \(session)")
                showLocalNotification(title: "Wallet connected", body: "Open the App to proceed")
                WC_Manager.shared.sessionMeta = .init(session: session, walletOnSameDevice: !self.qrDisplayed)
                Tracker.track(.walletConnected, parameters: ["wallet": session.peer.name])
            }
            .store(in: &cancellables)
    }
}
