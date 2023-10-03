//
//  Wallet.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 07.09.23.
//

import Foundation

struct Wallet: Identifiable {
    let image: String
    let name: String
    let link: URL
    let id: String

    // MARK: -Recommended default wallets

    static let recommended: [Wallet] = [.zerion, .rainbow, .oneInch, .uniswap]

    static let zerion = Wallet(
        image: "zerion",
        name: "Zerion",
        link: URL(string: "https://wallet.zerion.io")!,
        id: "ecc4036f814562b41a5268adc86270fba1365471402006302e70169465b7ac18"
    )

    static let rainbow = Wallet(
        image: "rainbow",
        name: "Rainbow",
        link: URL(string: "https://rnbwapp.com")!,
        id: "1ae92b26df02f0abca6304df07debccd18262fdf5fe82daa81593582dac9a369"
    )

    static let oneInch = Wallet(
        image: "oneInch",
        name: "1Inch",
        link: URL(string: "https://wallet.1inch.io")!,
        id: "c286eebc742a537cd1d6818363e9dc53b21759a1e8e5d9b263d0c03ec7703576"
    )

    static let uniswap = Wallet(
        image: "uniswap",
        name: "Uniswap",
        link: URL(string: "https://uniswap.org/app")!,
        id: "c03dfee351b6fcc421b4494ea33b9d4b92a984f87aa76d1663bb28705e95034a"
    )
}
