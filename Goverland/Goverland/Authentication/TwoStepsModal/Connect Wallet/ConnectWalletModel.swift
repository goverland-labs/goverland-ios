//
//  ConnectWalletModel.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 30.08.23.
//

import Foundation
import WalletConnectModal

class ConnectWalletModel: ObservableObject {
    @Published private(set) var connecting = false

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
}
