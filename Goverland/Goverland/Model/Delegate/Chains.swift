//
//  Chains.swift
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

struct Chains: Decodable {
    let eth: Chain
    let gnosis: Chain
}
