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

    func test_whenDelegatingToSelf_and_noPrioDelegations() throws {
        let model = UserDelegationSplitViewModel(
            owner: .appUser,
            userDelegation: DaoUserDelegation(dao: .aave,
                                              votingPower: .init(symbol: "UTI", power: 12.5),
                                              chains: .testChains,
                                              delegates: [],
                                              expirationDate: nil),
            tappedDelegate: .appUser)

        // TODO: test:
        // - ownerPowerReserved
        // - delegates
        //
//        XCTAssertEqual(model.stringWithMetric(from: 710155) , "710K")
        XCTAssertTrue(true)
    }

}
