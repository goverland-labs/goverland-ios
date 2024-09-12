//
//  TxStatus.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 11.09.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct TxStatus: Decodable {
    let status: Status

    enum Status: String, Decodable {
        case pending
        case success
        case failed
    }
}
