//
//  Utils.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 17.06.23.
//

import Foundation

enum Utils {
    static func getTotal(from headers: HttpHeaders) -> Int? {
        guard let totalStr = headers["x-total-count"] as? String,
            let total = Int(totalStr) else {
            // TODO: log in crashlytics
            return nil
        }
        return total
    }

    static func formattedNumber(_ number: Double) -> String {
        let formatter = MetricNumberFormatter()
        return formatter.stringWithMetric(from: number) ?? ""
    }

    static func percentage(of currentNumber: Double, in totalNumber: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.positiveSuffix = "%"
        let formattedString = formatter.string(from: NSNumber(value: currentNumber / totalNumber))
        return formattedString ?? ""
    }
}
