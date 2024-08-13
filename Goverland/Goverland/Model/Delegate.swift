//
//  Delegate.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 11.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//


import Foundation

struct Delegate: Identifiable, Decodable, Equatable {
    let id: UUID
    let user: User
    let about: String
    let statement: String
    //let userDelegated: Bool?
    let delegators: Int
    let votes: Int
    let proposalsCreated: Int
    let votingPower: Double
    let percentVotingPower: Double
    let delegationInfo: DelegationInfo?
    
    enum CodingKeys: String, CodingKey {
        case id
        case user
        case about
        case statement
        //case userDelegated = "user_delegation_info"
        case delegators = "delegator_count"
        case votes = "votes_count"
        case proposalsCreated = "created_proposals_count"
        case votingPower = "voting_power"
        case percentVotingPower = "percent_of_voting_power"
        case delegationInfo = "user_delegation_info"
    }
}

struct DelegationInfo: Decodable, Equatable {
    let percentDelegated: Double
    
    enum CodingKeys: String, CodingKey {
        case percentDelegated = "percent_of_delegated"
    }
}

struct DelegateVotingPower: Decodable {
    let user: User
    let powerPercent: Double
    let powerRatio: Int
    
    enum CodingKeys: String, CodingKey {
        case user
        case powerPercent = "percent_of_delegated"
        case powerRatio = "ratio"
    }
}

struct DelegateProfile: Decodable {
    let dao: Dao
    let votingPower: VotingPower
    let chains: [Chain]
    let delegates: [DelegateVotingPower]
    let expirationDate: String?
    
    enum CodingKeys: String, CodingKey {
        case dao
        case votingPower = "voting_power"
        case chains
        case delegates
        case expirationDate = "expiration_date"
    }
    
    struct VotingPower: Decodable {
        let symbol: String
        let power: Double
    }
}

struct Chains: Decodable {
    let eth: Chain
    let gnosis: Chain
}

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

extension Delegate {
    static let delegateAaveChan = Delegate(id: UUID(),
                                           user: .aaveChan,
                                           about: "Delegate aaveChan about information",
                                           statement: "Delegate aaveChan statement should be here",
                                           delegators: 20,
                                           votes: 21,
                                           proposalsCreated: 1,
                                           votingPower: 14285728.4328434,
                                           percentVotingPower: 1.12,
                                           delegationInfo: .testDelegationInfo)
    static let delegateNoDelegated = Delegate(id: UUID(),
                                           user: .test,
                                           about: "Delegate aaveChan about information",
                                           statement: "Delegate aaveChan statement should be here",
                                           delegators: 20,
                                           votes: 21,
                                           proposalsCreated: 1,
                                           votingPower: 14285728.4328434,
                                           percentVotingPower: 1.12,
                                           delegationInfo: nil)
}

extension DelegationInfo {
    static let testDelegationInfo = DelegationInfo(percentDelegated: 100.0)
}

extension DelegateVotingPower {
    static let delegateAaveChan = DelegateVotingPower(user: .aaveChan,
                                                      powerPercent: 33.3,
                                                      powerRatio: 2)
    static let delegateFlipside = DelegateVotingPower(user: .flipside,
                                                      powerPercent: 66.6,
                                                      powerRatio: 1)
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

extension Chains {
    static let testChains = Chains(eth: .etherium, gnosis: .gnosis)
}
