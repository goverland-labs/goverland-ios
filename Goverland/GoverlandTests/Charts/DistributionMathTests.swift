//
//  DistributionMathTests.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 18.09.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import XCTest
@testable import Goverland

final class DistributionMathTests: XCTestCase {

    func test_squareRootBins() {
        let values = [1, 2, 2.5, 3, 3, 3, 3, 4, 4, 4, 5, 5, 6, 7, 7, 7.5, 7.8, 10, 10.5, 11, 11.1, 11.2, 11.3, 15, 15, 25, 32, 65, 130, 300, 301]
        let bins = DistributionMath.calculateSquareRootBins(values: values)
        XCTAssertEqual(bins.count, 5)
    }
}
