//
//  Wallet.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 07.09.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation
import UIKit

struct Wallet: Identifiable {
    let image: String
    let name: String
    let link: URL
    let scheme: String
    let id: String

    // MARK: - Recommended default wallets

    private static let _required: [Wallet] = [.zerion]
    private static let _recommended: [Wallet] = [.metamask, .rainbow, .trust]

    static var recommended: [Wallet] {
        var wallets = _required
        for w in _recommended {
            if let url = URL(string: "\(w.scheme)://"), UIApplication.shared.canOpenURL(url) {
                wallets.append(w)
            }
        }
        return Array(wallets.prefix(4))
    }

    static var excluded: [Wallet] {
        // here we will exclude all wallets that poorly work
        return recommended // + [.mew, .uniswap]
    }

    private static let _all: [Wallet] = [.zerion, .rainbow, .metamask, .uniswap, .oneInch, .trust]

    static func by(name: String) -> Wallet? {
        if name == "MetaMask Wallet" {
            return .metamask
        }
        return _all.first { $0.name == name }
    }

    static let zerion = Wallet(
        image: "zerion",
        name: "Zerion",
        link: URL(string: "https://wallet.zerion.io")!,
        scheme: "zerion",
        id: "ecc4036f814562b41a5268adc86270fba1365471402006302e70169465b7ac18"
    )

    static let rainbow = Wallet(
        image: "rainbow",
        name: "Rainbow",
        link: URL(string: "https://rnbwapp.com")!,
        scheme: "rainbow",
        id: "1ae92b26df02f0abca6304df07debccd18262fdf5fe82daa81593582dac9a369"
    )

    static let metamask = Wallet(
        image: "metamask",
        name: "MetaMask",
        link: URL(string: "https://metamask.app.link")!,
        scheme: "metamask",
        id: "c57ca95b47569778a828d19178114f4db188b89b763c899ba0be274e97267d96")

    static let uniswap = Wallet(
        image: "uniswap",
        name: "Uniswap",
        link: URL(string: "https://uniswap.org/app")!,
        scheme: "uniswap",
        id: "c03dfee351b6fcc421b4494ea33b9d4b92a984f87aa76d1663bb28705e95034a"
    )

    static let oneInch = Wallet(
        image: "oneInch",
        name: "1Inch",
        link: URL(string: "https://wallet.1inch.io")!,
        scheme: "oneinch",
        id: "c286eebc742a537cd1d6818363e9dc53b21759a1e8e5d9b263d0c03ec7703576"
    )

    static let trust = Wallet(
        image: "trust",
        name: "Trust Wallet",
        link: URL(string: "https://link.trustwallet.com")!,
        scheme: "trust",
        id: "4622a2b2d6af1c9844944291e5e7351a6aa24cd7b23099efac1b2fd875da31a0")

    // MARK: - Doesn't support eth_signTypedData(_v4)

    // - MEW Wallet

    // MARK: - Unstable with WalletConnect

    // - Uniswap Wallet


    // MARK: - Tested SIWE + eth_signTypedData_v4

    // - MetaMask, Zerion, Rainbow, Trust, 1Inch
}
