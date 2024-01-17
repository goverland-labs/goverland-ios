//
//  CoinbaseWalletManager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 16.01.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import CoinbaseWalletSDK

class CoinbaseWalletManager {
    static let shared = CoinbaseWalletManager()

    private init() {
        configure()
        getStoredAccount()
    }

    var account: Account? {
        didSet {
            NotificationCenter.default.post(name: .cbWalletAccountUpdated, object: account)
        }
    }

    static func disconnect() {
        logInfo("[CoinbaseWallet] App disconnecting from wallet")
        CoinbaseWalletSDK.shared.resetSession()
        Task {
            try! await UserProfile.clearCoinbaseAccounts()
        }
    }

    private func configure() {
        CoinbaseWalletSDK.configure(
            callback: URL(string: "https://links.goverland.xyz")!
        )
    }

    private func getStoredAccount() {
        Task {
            if let selectedProfile = try? await UserProfile.selected(),
                let cbAccountData = selectedProfile.cbAccountData,
                let account = Account.from(data: cbAccountData)
            {
                self.account = account
            }
        }
    }
}
