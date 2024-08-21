//
//  Chain.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-08-20.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct Chain: Decodable {
    let id: Int
    let name: String
    let balance: Double
    let symbol: String
    let feeApproximation: Double
    let txScanTemplate: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case balance
        case symbol
        case feeApproximation = "fee_approximation"
        case txScanTemplate = "tx_scan_template"
    }
}

extension Chain {
    static let gnosis = Chain(id: 100,
                              name: "Gnosis Chain",
                              balance: 10.0,
                              symbol: "xDai",
                              feeApproximation: 0.001,
                              txScanTemplate: "https://gnosisscan.io/tx/:id")
    static let etherium = Chain(id: 1,
                                name: "Ethereum",
                                balance: 0.01,
                                symbol: "Eth",
                                feeApproximation: 0.02,
                                txScanTemplate: "https://etherscan.io/tx/:id")
}
