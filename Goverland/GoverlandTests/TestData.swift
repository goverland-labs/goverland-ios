//
//  TestData.swift
//  GoverlandTests
//
//  Created by Andrey Scherbovich on 29.08.24.
//  Copyright © Goverland Inc. All rights reserved.
//


import Foundation
import SwiftDate

// MARK: - User

extension User {
    static var appUser: User {
        User(address: Address("0x41BD554fA82193cB7AE30224CA4e3c55b473e21d"),
             resolvedName: nil,
             avatars: [
                Avatar(size: .xs, link: URL(string: "https://cdn.stamp.fyi/avatar/0x41BD554fA82193cB7AE30224CA4e3c55b473e21d?s=32")!),
                Avatar(size: .s, link: URL(string: "https://cdn.stamp.fyi/avatar/0x41BD554fA82193cB7AE30224CA4e3c55b473e21d?s=52")!),
                Avatar(size: .m, link: URL(string: "https://cdn.stamp.fyi/avatar/0x41BD554fA82193cB7AE30224CA4e3c55b473e21d?s=92")!),
                Avatar(size: .l, link: URL(string: "https://cdn.stamp.fyi/avatar/0x41BD554fA82193cB7AE30224CA4e3c55b473e21d?s=152")!),
                Avatar(size: .xl, link: URL(string: "https://cdn.stamp.fyi/avatar/0x41BD554fA82193cB7AE30224CA4e3c55b473e21d?s=180")!)
             ])
    }

    static var test: User {
        User(address: Address("0x46F228b5eFD19Be20952152c549ee478Bf1bf36b"),
             resolvedName: nil,
             avatars: [
                Avatar(size: .xs, link: URL(string: "https://cdn.stamp.fyi/avatar/eth:0x329c54289Ff5D6B7b7daE13592C6B1EDA1543eD4?s=138")!),
                Avatar(size: .s, link: URL(string: "https://cdn.stamp.fyi/avatar/eth:0x329c54289Ff5D6B7b7daE13592C6B1EDA1543eD4?s=138")!),
                Avatar(size: .m, link: URL(string: "https://cdn.stamp.fyi/avatar/eth:0x329c54289Ff5D6B7b7daE13592C6B1EDA1543eD4?s=138")!),
                Avatar(size: .l, link: URL(string: "https://cdn.stamp.fyi/avatar/eth:0x329c54289Ff5D6B7b7daE13592C6B1EDA1543eD4?s=138")!),
                Avatar(size: .xl, link: URL(string: "https://cdn.stamp.fyi/avatar/eth:0x329c54289Ff5D6B7b7daE13592C6B1EDA1543eD4?s=138")!)
             ])
    }

    static var flipside: User {
        User(address: Address("0x62a43123FE71f9764f26554b3F5017627996816a"),
             resolvedName: "flipsidecrypto.eth",
             avatars: [
                Avatar(size: .xs, link: URL(string: "https://cdn.stamp.fyi/avatar/eth:0x62a43123FE71f9764f26554b3F5017627996816a?s=138")!),
                Avatar(size: .s, link: URL(string: "https://cdn.stamp.fyi/avatar/eth:0x62a43123FE71f9764f26554b3F5017627996816a?s=138")!),
                Avatar(size: .m, link: URL(string: "https://cdn.stamp.fyi/avatar/eth:0x62a43123FE71f9764f26554b3F5017627996816a?s=138")!),
                Avatar(size: .l, link: URL(string: "https://cdn.stamp.fyi/avatar/eth:0x62a43123FE71f9764f26554b3F5017627996816a?s=138")!),
                Avatar(size: .xl, link: URL(string: "https://cdn.stamp.fyi/avatar/eth:0x62a43123FE71f9764f26554b3F5017627996816a?s=138")!)
             ])
    }

    static var aaveChan: User {
        User(address: Address("0x329c54289Ff5D6B7b7daE13592C6B1EDA1543eD4"),
             resolvedName: "aavechan.eth",
             avatars: [
                Avatar(size: .xs, link: URL(string: "https://cdn.stamp.fyi/avatar/eth:0x329c54289Ff5D6B7b7daE13592C6B1EDA1543eD4?s=138")!),
                Avatar(size: .s, link: URL(string: "https://cdn.stamp.fyi/avatar/eth:0x329c54289Ff5D6B7b7daE13592C6B1EDA1543eD4?s=138")!),
                Avatar(size: .m, link: URL(string: "https://cdn.stamp.fyi/avatar/eth:0x329c54289Ff5D6B7b7daE13592C6B1EDA1543eD4?s=138")!),
                Avatar(size: .l, link: URL(string: "https://cdn.stamp.fyi/avatar/eth:0x329c54289Ff5D6B7b7daE13592C6B1EDA1543eD4?s=138")!),
                Avatar(size: .xl, link: URL(string: "https://cdn.stamp.fyi/avatar/eth:0x329c54289Ff5D6B7b7daE13592C6B1EDA1543eD4?s=138")!)
             ])
    }
}

// MARK: - Dao

extension Dao {
    static var gnosis: Dao {
        Dao(id: UUID(),
            alias: "gnosis.eth",
            name: "Gnosis DAO",
            avatars: [],
            createdAt: .now - 5.days,
            activitySince: .now - 1.years,
            about: [],
            categories: [.protocol],
            proposals: 100,
            voters: 4567,
            activeVotes: 2,
            verified: true,
            subscriptionMeta: nil,
            website: URL(string: "https://gnosis.io"),
            X: "gnosisdao",
            github: "gnosis",
            coingecko: "gnosis",
            terms: nil)
    }

    static var aave: Dao {
        Dao(id: UUID(),
            alias: "aave.eth",
            name: "Aave",
            avatars: [],
            createdAt: .now - 5.days,
            activitySince: .now - 1.years,
            about: [],
            categories: [.protocol],
            proposals: 150,
            voters: 45678,
            activeVotes: 20,
            verified: true,
            subscriptionMeta: nil,
            website: nil,
            X: "AaveAave",
            github: "aave",
            coingecko: "aave",
            terms: nil)
    }
}

// MARK: - Chains

extension Chain {
    static var gnosis: Chain {
        Chain(id: 100,
              name: "Gnosis Chain",
              balance: 10.0,
              symbol: "xDai",
              feeApproximation: 0.001,
              txScanTemplate: "https://gnosisscan.io/tx/:id")
    }
    static var etherium: Chain {
        Chain(id: 1,
              name: "Ethereum",
              balance: 0.01,
              symbol: "Eth",
              feeApproximation: 0.02,
              txScanTemplate: "https://etherscan.io/tx/:id")
    }
}

extension Chains {
    static var testChains: Chains { Chains(eth: .etherium, gnosis: .gnosis) }
}
