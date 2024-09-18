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

    func test_squareRootBins_1() {
        // 25 values
        // bins = |sqrt(25)| = 5
        // width = (max - min) / bins = (301 - 1) / 5 = 60.0
        let values = [
            1, 2, 2.5, 3, 3,
            3, 3, 4, 4, 4,
            5, 6, 7, 7, 7.5,
            10, 10.5, 11, 11.1, 11.2,
            11.3, 15, 15, 25, 32,
            61, 120.999, 181, 241, 301]

        let bins = DistributionMath.calculateSquareRootBins(values: values)
        XCTAssertEqual(bins.count, 5)

        // Bin 1: 1..<61
        XCTAssertEqual(bins[0].range.lowerBound, 1)
        XCTAssertEqual(bins[0].range.upperBound, 61)
        XCTAssertEqual(bins[0].count, 25)

        // Bin 2: 61..<121
        XCTAssertEqual(bins[1].range.lowerBound, 61)
        XCTAssertEqual(bins[1].range.upperBound, 121)
        XCTAssertEqual(bins[1].count, 2)

        // Bin 3: 121..<181
        XCTAssertEqual(bins[2].range.lowerBound, 121)
        XCTAssertEqual(bins[2].range.upperBound, 181)
        XCTAssertEqual(bins[2].count, 0)

        // Bin 4: 181..<241
        XCTAssertEqual(bins[3].range.lowerBound, 181)
        XCTAssertEqual(bins[3].range.upperBound, 241)
        XCTAssertEqual(bins[3].count, 1)

        // Bin 5: 241..<=301
        XCTAssertEqual(bins[4].range.lowerBound, 241)
        XCTAssertEqual(bins[4].range.upperBound, 301)
        XCTAssertEqual(bins[4].count, 2)
    }

    func test_squareRootBins_2() {
        // 17 values
        // bins = |sqrt(17)| = 4
        // width = (max - min) / bins = (10.5 - 1) / 5 = 2.375
        let values = [
            1, 2, 2.5, 3, 3,
            3, 3, 4, 4, 4,
            5, 6, 7, 7, 7.5,
            8, 10.5]

        let bins = DistributionMath.calculateSquareRootBins(values: values)
        XCTAssertEqual(bins.count, 4)

        // Bin 1: 1..<3 (|1 + 1 * 2.375|)
        XCTAssertEqual(bins[0].range.lowerBound, 1)
        XCTAssertEqual(bins[0].range.upperBound, 3)
        XCTAssertEqual(bins[0].count, 3)

        // Bin 2: 3..<5 (|1 + 2 * 2.375|)
        XCTAssertEqual(bins[1].range.lowerBound, 3)
        XCTAssertEqual(bins[1].range.upperBound, 5)
        XCTAssertEqual(bins[1].count, 7)

        // Bin 3: 5..<8 (|1 + 3 * 2.375|)
        XCTAssertEqual(bins[2].range.lowerBound, 5)
        XCTAssertEqual(bins[2].range.upperBound, 8)
        XCTAssertEqual(bins[2].count, 5)

        // Bin 4: 8..<=11 (ceil(1 + 4 * 2.375))
        XCTAssertEqual(bins[3].range.lowerBound, 8)
        XCTAssertEqual(bins[3].range.upperBound, 11)
        XCTAssertEqual(bins[3].count, 2)
    }
}
