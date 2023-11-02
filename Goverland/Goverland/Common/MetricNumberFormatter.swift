//
//  NumberFormatter.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 28.06.23.
//  Copyright © Goverland Inc. All rights reserved.
//

// Based on https://github.com/RenGate/MetricPrefixNumberFormatter
// Library distributed with MIT license

import Foundation

enum MetricSuffix: Int, CaseIterable {
    case yotta = 24
    case zetta = 21
    case exa = 18
    case peta = 15
    case tera = 12
    case giga = 9
    case mega = 6
    case kilo = 3
    case zero = 0
    case milli = -3
    case micro = -6
    case nano = -9
    case pico = -12
    case femto = -15
    case atto = -18
    case zepto = -21
    case yocto = -24

    static var latinSuffixes: [MetricSuffix: String] {
        return [
            .yotta: "Y",
            .zetta: "Z",
            .exa: "E",
            .peta: "P",
            .tera: "T",
            .giga: "G",
            .mega: "M",
            .kilo: "K",
            .zero: "",
            .milli: "m",
            .micro: "μ",
            .nano: "n",
            .pico: "p",
            .femto: "f",
            .atto: "a",
            .zepto: "z",
            .yocto: "y"
        ]
    }
}

extension MetricSuffix: Comparable {
    static func <(lhs:MetricSuffix, rhs: MetricSuffix) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

class MetricNumberFormatter: NumberFormatter {
    var delimiter: String = ""
    var decimals: Int = 2
    var localizationDictionary: [MetricSuffix: String] = MetricSuffix.latinSuffixes

    public func stringWithMetric(from number: NSNumber) -> String? {
        let numberAsDouble = number.doubleValue
        guard !numberAsDouble.isNaN else { return nil }
        let suffix: MetricSuffix
        let scaledNumber: NSNumber

        if number == 0 {
            suffix = .zero
            scaledNumber = number
        } else {
            let orderOfMagnitude = Int(log10(fabs(numberAsDouble)))
            let smallerOrEqualSuffixes = MetricSuffix.allCases.filter { $0.rawValue <= orderOfMagnitude }
            suffix = smallerOrEqualSuffixes.max() ?? MetricSuffix.yocto
            scaledNumber = NSNumber(value: numberAsDouble / pow(10.0, Double(suffix.rawValue)))
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = decimals

        guard let formattedNumber = formatter.string(from: scaledNumber) else { return nil }

        if suffix == .zero {
            return formattedNumber
        }
        return "\(formattedNumber)\(delimiter)\(localizationDictionary[suffix] ?? "")"
    }
}

extension MetricNumberFormatter {
    func stringWithMetric(from number: Double) -> String? {
        return stringWithMetric(from: NSNumber(value: number))
    }

    func stringWithMetric(from number: Float) -> String? {
        return stringWithMetric(from: NSNumber(value: number))
    }

    func stringWithMetric(from number: Int) -> String? {
        return stringWithMetric(from: NSNumber(value: number))
    }

    func stringWithMetric(from number: Int64) -> String? {
        return stringWithMetric(from: NSNumber(value: number))
    }

    func stringWithMetric(from number: Int32) -> String? {
        return stringWithMetric(from: NSNumber(value: number))
    }

    func stringWithMetric(from number: Int16) -> String? {
        return stringWithMetric(from: NSNumber(value: number))
    }

    func stringWithMetric(from number: Int8) -> String? {
        return stringWithMetric(from: NSNumber(value: number))
    }

    func stringWithMetric(from number: UInt) -> String? {
        return stringWithMetric(from: NSNumber(value: number))
    }

    func stringWithMetric(from number: UInt64) -> String? {
        return stringWithMetric(from: NSNumber(value: number))
    }

    func stringWithMetric(from number: UInt32) -> String? {
        return stringWithMetric(from: NSNumber(value: number))
    }

    func stringWithMetric(from number: UInt16) -> String? {
        return stringWithMetric(from: NSNumber(value: number))
    }

    func stringWithMetric(from number: UInt8) -> String? {
        return stringWithMetric(from: NSNumber(value: number))
    }
}

