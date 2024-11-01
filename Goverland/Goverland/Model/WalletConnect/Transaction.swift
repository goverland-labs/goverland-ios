//
//  Transaction.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 03.09.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct Transaction: Codable {
    let from: String
    let to: String
    let data: String
    let gas: String
    let maxFeePerGas: String
    let maxPriorityFeePerGas: String
    let value: String
}

extension Transaction {
    static func from(_ address: String,
                     preparedDeleagtionData: DaoUserDelegationPreparedData) -> Transaction
    {
        Transaction(
            from: address,
            to: preparedDeleagtionData.to,
            data: preparedDeleagtionData.data,
            gas: preparedDeleagtionData.gas,
            maxFeePerGas: preparedDeleagtionData.maxFeePerGas,
            maxPriorityFeePerGas: preparedDeleagtionData.maxPriorityFeePerGas,
            value: "0x00"
        )
    }
}
