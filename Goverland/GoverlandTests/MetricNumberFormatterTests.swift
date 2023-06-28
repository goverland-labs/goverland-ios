//
//  GoverlandTests.swift
//  GoverlandTests
//
//  Created by Andrey Scherbovich on 28.06.23.
//

import XCTest
@testable import Goverland

final class MetricNumberFormatterTests: XCTestCase {
    var formatter: MetricNumberFormatter!

    override func setUp() {
        formatter = MetricNumberFormatter()
    }

    func testFormatter() {
        XCTAssertEqual(formatter.stringWithMetricPrefix(from: 14000000) , "14 M")
        XCTAssertEqual(formatter.stringWithMetricPrefix(from: 14658000) , "14.66 M")
        XCTAssertEqual(formatter.stringWithMetricPrefix(from: 0.000000000036) , "36 p")
        XCTAssertEqual(formatter.stringWithMetricPrefix(from: 0.73) , "0.73")
        XCTAssertEqual(formatter.stringWithMetricPrefix(from: 170000000) , "170 M")
        XCTAssertEqual(formatter.stringWithMetricPrefix(from: 1e-17) , "10 a")
        XCTAssertEqual(formatter.stringWithMetricPrefix(from: 0.0009) , "0.9 m")
        XCTAssertEqual(formatter.stringWithMetricPrefix(from: 2.4e-05) , "24 μ")
        XCTAssertEqual(formatter.stringWithMetricPrefix(from: 88000000000000) , "88 T")
        XCTAssertEqual(formatter.stringWithMetricPrefix(from: 760000) , "760 K")
    }

    func testDelimiter() {
        formatter.delimiter = ""
        XCTAssertEqual(formatter.stringWithMetricPrefix(from: 710155) , "710.16K")
        XCTAssertEqual(formatter.stringWithMetricPrefix(from: 0.00086) , "0.86m")
    }

    func testLocalization() {
        var dictionary = formatter.localizationDictionary
        dictionary[.kilo] = "к"
        dictionary[.nano] = "н"
        formatter.localizationDictionary = dictionary

        XCTAssertEqual(formatter.stringWithMetricPrefix(from: 5490) , "5.49 к")
        XCTAssertEqual(formatter.stringWithMetricPrefix(from: 1e-9) , "1 н")
    }
}
