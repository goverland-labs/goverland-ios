//
//  Utils.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 17.06.23.
//

import Foundation
import OSLog

fileprivate let logger = Logger()

func logInfo(_ message: String) {
    logger.info("\(message)")
}

func logError(_ error: Error, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
    // TODO: log in crashlytics
    let filePath = "\(file)"
    let fileName = (filePath as NSString).lastPathComponent
    logger.error("[ERROR] \(fileName): \(line): \(function) \(error.localizedDescription)")
}

enum Utils {
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

    static func formattedNumber(_ number: Double) -> String {
        let formatter = MetricNumberFormatter()
        return formatter.stringWithMetric(from: number) ?? ""
    }

    static func mediumDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
    
    static func mediumDateNoTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }

    static func percentage(of currentNumber: Double, in totalNumber: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.positiveSuffix = "%"
        let formattedString = formatter.string(from: NSNumber(value: currentNumber / totalNumber))
        return formattedString ?? ""
    }

    static func urlFromString(_ string: String) -> URL? {
        if let percentEncodedString = string.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
           let url = URL(string: percentEncodedString.replacingOccurrences(of: "%23", with: "#")) { // snapshot doesn't work with %23
            return url
        }
        return nil
    }
}
