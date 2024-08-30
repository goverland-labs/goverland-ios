//
//  GoverlandTests.swift
//  GoverlandTests
//
//  Created by Andrey Scherbovich on 28.06.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import XCTest
@testable import Goverland

final class MetricNumberFormatterTests: XCTestCase {
    var formatter: MetricNumberFormatter!

    var decimalSeparator: String {
        formatter.numberFormatter.decimalSeparator
    }

    override func setUp() {
        formatter = MetricNumberFormatter()
    }

    func testFormatter() {
        formatter.delimiter = ""
        XCTAssertEqual(formatter.stringWithMetric(from: 710155) , "710K")
        XCTAssertEqual(formatter.stringWithMetric(from: 0.00086) , "0\(decimalSeparator)86m")

        formatter.delimiter = " "
        XCTAssertEqual(formatter.stringWithMetric(from: 14000000) , "14 M")
        XCTAssertEqual(formatter.stringWithMetric(from: 14658000) , "14\(decimalSeparator)66 M")
        XCTAssertEqual(formatter.stringWithMetric(from: 0.000000000036) , "36 p")
        XCTAssertEqual(formatter.stringWithMetric(from: 0.73) , "0\(decimalSeparator)73")
        XCTAssertEqual(formatter.stringWithMetric(from: 170000000) , "170 M")
        XCTAssertEqual(formatter.stringWithMetric(from: 1e-17) , "10 a")
        XCTAssertEqual(formatter.stringWithMetric(from: 0.0009) , "0\(decimalSeparator)9 m")
        XCTAssertEqual(formatter.stringWithMetric(from: 2.4e-05) , "24 μ")
        XCTAssertEqual(formatter.stringWithMetric(from: 88000000000000) , "88 T")
        XCTAssertEqual(formatter.stringWithMetric(from: 760000) , "760 K")
    }

    func testLocalization() {
        var dictionary = formatter.localizationDictionary
        dictionary[.kilo] = "к"
        dictionary[.nano] = "н"
        formatter.localizationDictionary = dictionary
        formatter.delimiter = " "

        XCTAssertEqual(formatter.stringWithMetric(from: 5490) , "5\(decimalSeparator)5 к")
        XCTAssertEqual(formatter.stringWithMetric(from: 1e-9) , "1 н")
    }
}
