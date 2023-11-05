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

class ConnectWalletModel: ObservableObject {
    @Published private(set) var connecting = false
    @Published private(set) var qrDisplayed = false

    private var cancelables = Set<AnyCancellable>()

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
        connecting = false
    }

    private func listen_WC() {
        Sign.instance.sessionSettlePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] session in
                logInfo("[WC] Session settle: \(session)")
                guard let `self` = self else { return }
                WC_Manager.shared.sessionMeta = .init(session: session, walletOnSameDevice: !self.qrDisplayed)
                NotificationCenter.default.post(name: .wcSessionUpdated, object: WC_Manager.shared.sessionMeta)
            }
            .store(in: &cancelables)
    }
}
