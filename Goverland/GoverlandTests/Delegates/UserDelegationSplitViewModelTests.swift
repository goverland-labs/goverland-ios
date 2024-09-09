//
//  UserDelegationSplitViewModelTests.swift
//  GoverlandTests
//
//  Created by Andrey Scherbovich on 29.08.24.
//  Copyright © Goverland Inc. All rights reserved.
//


import XCTest
@testable import Goverland

final class UserDelegationSplitViewModelTests: XCTestCase {
    
    // MARK: init delegates property
    
    func test_delegatingToSelf_and_noPriorDelegations() throws {
        let model = UserDelegationSplitViewModel(
            dao: .aave,
            owner: .appUser,
            userDelegation: DaoUserDelegation(dao: .aave,
                                              votingPower: .init(symbol: "UTI", power: 12.5),
                                              chains: .testChains,
                                              delegates: [],
                                              expirationDate: nil),
            delegate: .appUser)
        
        XCTAssertEqual(model.ownerReservedPercentage, 100)
        XCTAssertEqual(model.delegates.count, 0)
    }

    func test_delegatingToSelf_and_hasPriorDelegations_noSelf() throws {
        let model = UserDelegationSplitViewModel(
            dao: .aave,
            owner: .appUser,
            userDelegation: DaoUserDelegation(dao: .aave,
                                              votingPower: .init(symbol: "UTI", power: 12.5),
                                              chains: .testChains,
                                              delegates: [DelegateVotingPower(user: .aaveChan,
                                                                              powerPercent: 66.6,
                                                                              powerRatio: 2),
                                                          DelegateVotingPower(user: .flipside,
                                                                              powerPercent: 33.3,
                                                                              powerRatio: 1)],
                                              expirationDate: nil),
            delegate: .appUser)
        
        XCTAssertEqual(model.ownerReservedPercentage , 0)
        XCTAssertTrue(model.delegates[0].user == .aaveChan)
        XCTAssertEqual(model.delegates[0].powerRatio, 2)
        XCTAssertTrue(model.delegates[1].user == .flipside)
        XCTAssertEqual(model.delegates[1].powerRatio, 1)
        XCTAssertEqual(model.delegates.count, 2)
    }

    func test_delegatingToSelf_and_hasPriorDelegations_withSelf() throws {
        let model = UserDelegationSplitViewModel(
            dao: .aave,
            owner: .appUser,
            userDelegation: DaoUserDelegation(dao: .aave,
                                              votingPower: .init(symbol: "UTI", power: 12.5),
                                              chains: .testChains,
                                              delegates: [DelegateVotingPower(user: .aaveChan,
                                                                              powerPercent: 33.3,
                                                                              powerRatio: 1),
                                                          DelegateVotingPower(user: .appUser,
                                                                              powerPercent: 10.0,
                                                                              powerRatio: 0),
                                                          DelegateVotingPower(user: .flipside,
                                                                              powerPercent: 66.6,
                                                                              powerRatio: 2)],
                                              expirationDate: nil),
            delegate: .appUser)
        
        XCTAssertEqual(model.ownerReservedPercentage , 10.0)
        XCTAssertTrue(model.delegates[0].user == .aaveChan)
        XCTAssertEqual(model.delegates[0].powerRatio, 1)
        XCTAssertTrue(model.delegates[1].user == .flipside)
        XCTAssertEqual(model.delegates[1].powerRatio, 2)
        XCTAssertEqual(model.delegates.count, 2)
    }
    
    func test_delegatingToDelegate_and_noPriorDelegations() throws {
        let model = UserDelegationSplitViewModel(
            dao: .aave,
            owner: .appUser,
            userDelegation: DaoUserDelegation(dao: .aave,
                                              votingPower: .init(symbol: "UTI", power: 12.5),
                                              chains: .testChains,
                                              delegates: [],
                                              expirationDate: nil),
            delegate: .aaveChan)
        
        XCTAssertEqual(model.ownerReservedPercentage , 0)
        XCTAssertTrue(model.delegates.first?.user == .aaveChan)
        XCTAssertEqual(model.delegates.first?.powerRatio, 1)
        XCTAssertEqual(model.delegates.count, 1)
    }

    func test_delegatingToDelegate_and_hasPriorDelegations_noSelf_noDelegate() throws {
        let model = UserDelegationSplitViewModel(
            dao: .aave,
            owner: .appUser,
            userDelegation: DaoUserDelegation(dao: .aave,
                                              votingPower: .init(symbol: "UTI", power: 12.5),
                                              chains: .testChains,
                                              delegates: [DelegateVotingPower(user: .aaveChan,
                                                                              powerPercent: 33.3,
                                                                              powerRatio: 2),
                                                          DelegateVotingPower(user: .flipside,
                                                                              powerPercent: 66.6,
                                                                              powerRatio: 1)],
                                              expirationDate: nil),
            delegate: .test)
        
        XCTAssertEqual(model.ownerReservedPercentage , 0)
        XCTAssertTrue(model.delegates[0].user == .test)
        XCTAssertEqual(model.delegates[0].powerRatio, 0)
        XCTAssertTrue(model.delegates[1].user == .aaveChan)
        XCTAssertEqual(model.delegates[1].powerRatio, 2)
        XCTAssertTrue(model.delegates[2].user == .flipside)
        XCTAssertEqual(model.delegates[2].powerRatio, 1)
        XCTAssertEqual(model.delegates.count, 3)
    }

    func test_delegatingToDelegate_and_hasPriorDelegations_withSelf_noDelegate() throws {
        let model = UserDelegationSplitViewModel(
            dao: .aave,
            owner: .appUser,
            userDelegation: DaoUserDelegation(dao: .aave,
                                              votingPower: .init(symbol: "UTI", power: 12.5),
                                              chains: .testChains,
                                              delegates: [DelegateVotingPower(user: .aaveChan,
                                                                              powerPercent: 33.3,
                                                                              powerRatio: 2),
                                                          DelegateVotingPower(user: .appUser,
                                                                              powerPercent: 10.0,
                                                                              powerRatio: 0),
                                                          DelegateVotingPower(user: .flipside,
                                                                              powerPercent: 66.6,
                                                                              powerRatio: 1)],
                                              expirationDate: nil),
            delegate: .test)
        
        XCTAssertEqual(model.ownerReservedPercentage , 10.0)
        XCTAssertTrue(model.delegates[0].user == .test)
        XCTAssertEqual(model.delegates[0].powerRatio, 0)
        XCTAssertTrue(model.delegates[1].user == .aaveChan)
        XCTAssertEqual(model.delegates[1].powerRatio, 2)
        XCTAssertTrue(model.delegates[2].user == .flipside)
        XCTAssertEqual(model.delegates[2].powerRatio, 1)
        XCTAssertEqual(model.delegates.count, 3)
    }

    func test_delegatingToDelegate_and_hasPriorDelegations_noSelf_withDelegate() throws {
        let model = UserDelegationSplitViewModel(
            dao: .aave,
            owner: .appUser,
            userDelegation: DaoUserDelegation(dao: .aave,
                                              votingPower: .init(symbol: "UTI", power: 12.5),
                                              chains: .testChains,
                                              delegates: [DelegateVotingPower(user: .aaveChan,
                                                                              powerPercent: 50.0,
                                                                              powerRatio: 2),
                                                          DelegateVotingPower(user: .test,
                                                                              powerPercent: 25.0,
                                                                              powerRatio: 1),
                                                          DelegateVotingPower(user: .flipside,
                                                                              powerPercent: 25.0,
                                                                              powerRatio: 1)],
                                              expirationDate: nil),
            delegate: .test)
        
        XCTAssertEqual(model.ownerReservedPercentage , 0)
        XCTAssertTrue(model.delegates[0].user == .aaveChan)
        XCTAssertEqual(model.delegates[0].powerRatio, 2)
        XCTAssertTrue(model.delegates[1].user == .test)
        XCTAssertEqual(model.delegates[1].powerRatio, 1)
        XCTAssertTrue(model.delegates[2].user == .flipside)
        XCTAssertEqual(model.delegates[2].powerRatio, 1)
        XCTAssertEqual(model.delegates.count, 3)
    }

    func test_delegatingToDelegate_and_hasPriorDelegations_withSelf_withDelegate() throws {
        let model = UserDelegationSplitViewModel(
            dao: .aave,
            owner: .appUser,
            userDelegation: DaoUserDelegation(dao: .aave,
                                              votingPower: .init(symbol: "UTI", power: 12.5),
                                              chains: .testChains,
                                              delegates: [DelegateVotingPower(user: .aaveChan,
                                                                              powerPercent: 40.0,
                                                                              powerRatio: 2),
                                                          DelegateVotingPower(user: .appUser,
                                                                              powerPercent: 20.0,
                                                                              powerRatio: 1),
                                                          DelegateVotingPower(user: .test,
                                                                              powerPercent: 20.0,
                                                                              powerRatio: 1),
                                                          DelegateVotingPower(user: .flipside,
                                                                              powerPercent: 20.0,
                                                                              powerRatio: 1)],
                                              expirationDate: nil),
            delegate: .test)
        
        XCTAssertEqual(model.ownerReservedPercentage , 20.0)
        XCTAssertTrue(model.delegates[0].user == .aaveChan)
        XCTAssertEqual(model.delegates[0].powerRatio, 2)
        XCTAssertTrue(model.delegates[1].user == .test)
        XCTAssertEqual(model.delegates[1].powerRatio, 1)
        XCTAssertTrue(model.delegates[2].user == .flipside)
        XCTAssertEqual(model.delegates[2].powerRatio, 1)
        XCTAssertEqual(model.delegates.count, 3)
    }
    
    func test_normalizing_delegates() throws {
        let model = UserDelegationSplitViewModel(
            dao: .aave,
            owner: .appUser,
            userDelegation: DaoUserDelegation(dao: .aave,
                                              votingPower: .init(symbol: "UTI", power: 12.5),
                                              chains: .testChains,
                                              delegates: [DelegateVotingPower(user: .aaveChan,
                                                                              powerPercent: 40.0,
                                                                              powerRatio: 4),
                                                          DelegateVotingPower(user: .appUser,
                                                                              powerPercent: 20.0,
                                                                              powerRatio: 2),
                                                          DelegateVotingPower(user: .test,
                                                                              powerPercent: 20.0,
                                                                              powerRatio: 2),
                                                          DelegateVotingPower(user: .flipside,
                                                                              powerPercent: 20.0,
                                                                              powerRatio: 2)],
                                              expirationDate: nil),
            delegate: .test)
        
        XCTAssertEqual(model.ownerReservedPercentage , 20.0)
        XCTAssertTrue(model.delegates[0].user == .aaveChan)
        XCTAssertEqual(model.delegates[0].powerRatio, 2)
        XCTAssertTrue(model.delegates[1].user == .test)
        XCTAssertEqual(model.delegates[1].powerRatio, 1)
        XCTAssertTrue(model.delegates[2].user == .flipside)
        XCTAssertEqual(model.delegates[2].powerRatio, 1)
        XCTAssertEqual(model.delegates.count, 3)
        
    }
}
