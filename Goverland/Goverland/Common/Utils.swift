//
//  Utils.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 17.06.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation
import UIKit

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

func showLocalNotification(title: String, body: String?, delay: TimeInterval? = nil) {
    DispatchQueue.main.async {
        let content = UNMutableNotificationContent()
        content.title = title
        if let body {
            content.body = body
        }
        var trigger: UNTimeIntervalNotificationTrigger?
        if let delay {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        }
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}

func showEnablePushNotificationsIfNeeded(activeSheetManager: ActiveSheetManager) {    
    let now = Date().timeIntervalSinceReferenceDate
    let lastPromotedPushNotificationsTime = SettingKeys.shared.lastPromotedPushNotificationsTime
    let notificationsEnabled = SettingKeys.shared.notificationsEnabled
    if now - lastPromotedPushNotificationsTime > ConfigurationManager.enablePushNotificationsRequestInterval && !notificationsEnabled {
        logInfo("[App] Attempt to show Push notifications")
        // We make a delay for Sign In two steps screen to disappear
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Don't promote if some active sheet already displayed
            if activeSheetManager.activeSheet == nil {
                SettingKeys.shared.lastPromotedPushNotificationsTime = now
                activeSheetManager.activeSheet = .subscribeToNotifications
            }
        }
    }
}

enum Utils {
    // MARK: - Third Party Applications
    
    static func openDiscord() {
        let url = URL(string: "https://discord.gg/uerWdwtGkQ")!
        openUrl(url)
    }

    static func openAppStore() {
        let url = URL(string: "https://apps.apple.com/app/id6463441559")!
        openUrl(url)
    }
    
    static func openX() {
        let url = URL(string: "https://x.com/goverland_xyz")!
        openUrl(url)
    }
    
    
    // MARK: - HTTP Headers

    static func getTotal(from headers: HttpHeaders) -> Int? {
        guard let totalStr = headers["x-total-count"] as? String,
            let total = Int(totalStr) else {
            logError(GError.missingTotalCount)
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
    
    static func getTotalVotingPower(from headers: HttpHeaders) -> Double? {
        guard let totalStr = headers["x-total-avg-vp"] as? String,
            let total = Double(totalStr) else {
            logError(GError.missingTotalCount)
            return nil
        }
        return total
    }
    
    static func getNextPage(from headers: HttpHeaders) -> String? {
        guard let nextPageStr = headers["x-next-page"] as? String else {
            logError(GError.missingNextPage)
            return nil
        }
        return nextPageStr
    }

    // MARK: - Dates

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

    static func formatDateToMiddleOfMonth(_ date: Date) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month], from: date)
        components.timeZone = .gmt
        components.day = 15
        return calendar.date(from: components)!
    }

    // MARK: - Numbers

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

    // MARK: - Misc

    static func urlFromString(_ string: String) -> URL? {
        if let percentEncodedString = string.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
           let url = URL(string: percentEncodedString.replacingOccurrences(of: "%23", with: "#")) { // snapshot doesn't work with %23
            return url
        }
        return nil
    }
}
