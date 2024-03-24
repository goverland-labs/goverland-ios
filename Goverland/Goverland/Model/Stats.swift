//
//  Stats.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 22.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct Stats: Decodable {
    let daos: Daos
    let proposals: Proposals

    enum CodingKeys: String, CodingKey {
        case daos = "dao"
        case proposals
    }

    struct Daos: Decodable {
        let total: Int
        let totalVerified: Int

        enum CodingKeys: String, CodingKey {
            case total
            case totalVerified = "total_verified"
        }
    }

    struct Proposals: Decodable {
        let total: Int
    }
}
