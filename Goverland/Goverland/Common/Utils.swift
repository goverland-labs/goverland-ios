//
//  Utils.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 17.06.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation
import UIKit
import FirebaseCrashlytics
import OSLog

fileprivate let logger = Logger()

func logInfo(_ message: String) {
    logger.info("\(message)")
}

func logError(_ error: Error, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
    let filePath = "\(file)"
    let fileName = (filePath as NSString).lastPathComponent
    let description = (error as? GError)?.localizedDescription ?? error.localizedDescription
    let msg = "[ERROR] \(fileName): \(line): \(function) \(description)"
    logger.error("\(msg)")
    Crashlytics.crashlytics().log(msg)
}

func showToast(_ message: String) {
    DispatchQueue.main.async {
        ToastViewModel.shared.setErrorMessage(message)
    }
}

func openUrl(_ url: URL) {
    DispatchQueue.main.async {
        UIApplication.shared.open(url)
    }
}

enum Utils {
    // MARK: -HTTP Headers

    static func getTotal(from headers: HttpHeaders) -> Int? {
        guard let totalStr = headers["x-total-count"] as? String,
            let total = Int(totalStr) else {
            logError(GError.missingTotalCount)
            return nil
        }
        return total
    }

    static func getSubscriptionsCount(from headers: HttpHeaders) -> Int? {
        guard let totalStr = headers["x-subscriptions-count"] as? String,
            let total = Int(totalStr) else {
            logError(GError.missingSubscriptionsCount)
            return nil
        }
        return total
    }

    static func getUnreadEventsCount(from headers: HttpHeaders) -> Int? {
        guard let totalStr = headers["x-unread-count"] as? String,
            let total = Int(totalStr) else {
            logError(GError.missingUnreadCount)
            return nil
        }
        return total
    }

    // MARK: -Dates

    static func mediumDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }

    static func monthAndYear(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }

    static func formatDateToStartOfMonth(_ date: Date) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month], from: date)
        components.timeZone = .gmt
        return calendar.date(from: components)!
    }

    // MARK: -Numbers

    static func formattedNumber(_ number: Double) -> String {
        let formatter = MetricNumberFormatter()
        return formatter.stringWithMetric(from: number) ?? ""
    }

    static func percentage(of currentNumber: Int, in totalNumber: Int) -> String {
        return percentage(of: Double(currentNumber), in: Double(totalNumber))
    }

    static func percentage(of currentNumber: Double, in totalNumber: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.positiveSuffix = "%"
        var formattedString: String? = nil
        if totalNumber > 0 {
            formattedString = formatter.string(from: NSNumber(value: currentNumber / totalNumber))
        }
        return formattedString ?? ""
    }

    static func numberWithPercent(from number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.positiveSuffix = "%"
        let formattedString = formatter.string(from: NSNumber(value: Double(number) / 100))
        return formattedString ?? "\(number)%"
    }

    static func numberWithPercent(from number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.positiveSuffix = "%"
        let formattedString = formatter.string(from: NSNumber(value: Double(number) / 100))
        return formattedString ?? "\(number)%"
    }

    static func decimalNumber(from number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        let formattedString = formatter.string(from: NSNumber(value: number))
        return formattedString ?? String(number)
    }

    // MARK: -Misc

    static func urlFromString(_ string: String) -> URL? {
        if let percentEncodedString = string.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
           let url = URL(string: percentEncodedString.replacingOccurrences(of: "%23", with: "#")) { // snapshot doesn't work with %23
            return url
        }
        return nil
    }

    static func randomNumber_8_dgts() -> Int {
        let lowerBound = 10000000  // Minimum 8-digit number
        let upperBound = 99999999  // Maximum 8-digit number
        return Int(arc4random_uniform(UInt32(upperBound - lowerBound + 1))) + lowerBound
    }
}
