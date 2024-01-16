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
    }

    var account: Account? {
        didSet {
            NotificationCenter.default.post(name: .cbWalletAccountUpdated, object: account)
        }
    }

    private func configure() {
        CoinbaseWalletSDK.configure(
            callback: URL(string: "https://links.goverland.xyz")!
        )
    }
}
