//
//  UserBuckets.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-09-11.
//

import SwiftUI

struct UserBuckets: Decodable {
    let votes: String
    let voters: Double
    
    init(votes: String,
         voters: Double) {
        self.votes = votes
        self.voters = voters
    }
    
    enum CodingKeys: CodingKey {
        case votes
        case voters
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.votes = try container.decode(String.self, forKey: .votes)
        self.voters = try container.decode(Double.self, forKey: .voters)
    }
}
