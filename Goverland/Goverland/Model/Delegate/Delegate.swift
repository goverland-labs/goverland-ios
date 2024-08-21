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

extension Delegate {
    static let delegateAaveChan = Delegate(user: .aaveChan,
                                           about: "Delegate aaveChan about information",
                                           statement: "Delegate aaveChan statement should be here",
                                           delegators: 20,
                                           votes: 21,
                                           proposalsCreated: 1,
                                           votingPower: 14285728.4328434,
                                           percentVotingPower: 1.12,
                                           delegationInfo: .testDelegationInfo)
    static let delegateNoDelegated = Delegate(user: .test,
                                              about: "",
                                              statement: "Delegate aaveChan statement should be here",
                                              delegators: 20,
                                              votes: 21,
                                              proposalsCreated: 1,
                                              votingPower: 14285728.4328434,
                                              percentVotingPower: 1.12,
                                              delegationInfo: DelegationInfo(percentDelegated: 0.0))
}
