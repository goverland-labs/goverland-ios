//
//  DistributionMathTests.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 18.09.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import XCTest
@testable import Goverland

// TODO: finialize when backend is ready
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

    func test_logBins_1() {
        // 25 values: max=256, min = 1
        // bins = ceil(log2(256) - log2(1)) = 8
        let values = [
            1, 2, 2.5, 3, 3,
            3, 3, 4, 4, 4,
            5, 6, 7, 7, 7.5,
            10, 10.5, 11, 11.1, 11.2,
            11.3, 15, 15, 25, 32,
            61, 120.999, 181, 241, 256]

        let bins = DistributionMath.calculateLogarithmicBins(values: values)
        XCTAssertEqual(bins.count, 8)

        // Bin 1: 1..<2 (|2^(0 + 0)| ..< |2^(0 + 1)|)
        XCTAssertEqual(bins[0].range.lowerBound, 1)
        XCTAssertEqual(bins[0].range.upperBound, 2)
        XCTAssertEqual(bins[0].count, 1)

        // Bin 2: 2..<4 (|2^1| ..< |2^2|)
        XCTAssertEqual(bins[1].range.lowerBound, 2)
        XCTAssertEqual(bins[1].range.upperBound, 4)
        XCTAssertEqual(bins[1].count, 6)

        // Bin 3: 4..<8
        XCTAssertEqual(bins[2].range.lowerBound, 4)
        XCTAssertEqual(bins[2].range.upperBound, 8)
        XCTAssertEqual(bins[2].count, 8)

        // Bin 4: 8..<16
        XCTAssertEqual(bins[3].range.lowerBound, 8)
        XCTAssertEqual(bins[3].range.upperBound, 16)
        XCTAssertEqual(bins[3].count, 8)

        // Bin 5: 16..<32
        XCTAssertEqual(bins[4].range.lowerBound, 16)
        XCTAssertEqual(bins[4].range.upperBound, 32)
        XCTAssertEqual(bins[4].count, 1)

        // Bin 6: 32..<64
        XCTAssertEqual(bins[5].range.lowerBound, 32)
        XCTAssertEqual(bins[5].range.upperBound, 64)
        XCTAssertEqual(bins[5].count, 2)

        // Bin 7: 64..<128
        XCTAssertEqual(bins[6].range.lowerBound, 64)
        XCTAssertEqual(bins[6].range.upperBound, 128)
        XCTAssertEqual(bins[6].count, 1)

        // Bin 8: 128..<=256
        XCTAssertEqual(bins[7].range.lowerBound, 128)
        XCTAssertEqual(bins[7].range.upperBound, 256)
        XCTAssertEqual(bins[7].count, 3)
    }

    func test_logBins_2() {
        // 27 values: max=241, min = 1
        // bins = ceil(log2(241) - log2(2.1)) = ceil(7,9128 - 1,0703) = 7
        let values = [
            2.1, 2.2, 2.5, 3, 3,
            3, 3, 4, 4, 4,
            5, 6, 7, 7, 7.5,
            10, 10.5, 11, 11.1, 11.2,
            11.3, 15, 15, 25, 32,
            61, 67, 133.999, 240, 240,
            240.5, 241]

        let bins = DistributionMath.calculateLogarithmicBins(values: values)
        XCTAssertEqual(bins.count, 7)

        // Bin 1: 2..<4
        XCTAssertEqual(bins[0].range.lowerBound, 2)
        XCTAssertEqual(bins[0].range.upperBound, 4)
        XCTAssertEqual(bins[0].count, 7)

        // Bin 2: 4..<8
        XCTAssertEqual(bins[1].range.lowerBound, 4)
        XCTAssertEqual(bins[1].range.upperBound, 8)
        XCTAssertEqual(bins[1].count, 8)

        // Bin 3: 8..<16
        XCTAssertEqual(bins[2].range.lowerBound, 8)
        XCTAssertEqual(bins[2].range.upperBound, 16)
        XCTAssertEqual(bins[2].count, 8)

        // Bin 4: 16..<33 (|2^(1,0703 + 4)| ..< |2^(1,0703 + 5)|)
        XCTAssertEqual(bins[3].range.lowerBound, 16)
        XCTAssertEqual(bins[3].range.upperBound, 33)
        XCTAssertEqual(bins[3].count, 2)

        // Bin 5: 33..<67
        XCTAssertEqual(bins[4].range.lowerBound, 33)
        XCTAssertEqual(bins[4].range.upperBound, 67)
        XCTAssertEqual(bins[4].count, 1)

        // Bin 6: 67..<134
        XCTAssertEqual(bins[5].range.lowerBound, 67)
        XCTAssertEqual(bins[5].range.upperBound, 134)
        XCTAssertEqual(bins[5].count, 2)

        // Bin 7: 134..<=241
        XCTAssertEqual(bins[6].range.lowerBound, 134)
        XCTAssertEqual(bins[6].range.upperBound, 241)
        XCTAssertEqual(bins[6].count, 4)
    }

    // TODO: add tests with a lot of small numbers < 1
}
