//
//  ProposalAddressValidation.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct ValidationError: Error, Decodable {
    let message: String
    let code: Int
}

struct ProposalAddressValidation: Decodable {
    typealias VotingPower = Int

    let result: Result<VotingPower, ValidationError>

    enum CodingKeys: String, CodingKey {
        case ok = "ok"
        case votingPower = "voting_power"
        case error = "error"
    }

    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)

        let valid = try container.decode(Bool.self, forKey: .ok)
        let votingPower = try container.decode(Int.self, forKey: .votingPower)

        if valid {
            self.result = .success(votingPower)
        } else {
            let error = try container.decode(ValidationError.self, forKey: .error)
            self.result = .failure(error)
        }
    }
}
