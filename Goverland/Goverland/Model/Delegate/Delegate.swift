//
//  Delegate.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 11.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//


import Foundation

struct Delegate: Identifiable, Decodable, Equatable {
    let user: User
    let about: String
    let statement: String
    let delegators: Int
    let votes: Int
    let proposalsCreated: Int
    let votingPower: Double
    let percentVotingPower: Double
    let delegationInfo: DelegationInfo
    
    var id: String {
        user.address.value
    }
    
    enum CodingKeys: String, CodingKey {
        case user
        case about
        case statement
        case delegators = "delegator_count"
        case votes = "votes_count"
        case proposalsCreated = "created_proposals_count"
        case votingPower = "voting_power"
        case percentVotingPower = "percent_of_voting_power"
        case delegationInfo = "user_delegation_info"
    }
}
