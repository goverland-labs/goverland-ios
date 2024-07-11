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
    
    static func openWarpcast() {
        let url = URL(string: "https://warpcast.com/goverland")!
        openUrl(url)
    }
    
    static func openOrb() {
        let url = URL(string: "https://orb.club/@goverland")!
        openUrl(url)
    }
    
    static func openHey() {
        let url = URL(string: "https://hey.xyz/u/goverland")!
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
    
    static func getTotalAvgVotingPower(from headers: HttpHeaders) -> Double? {
        guard let totalStr = headers["x-total-avg-vp"] as? String,
            let total = Double(totalStr) else {
            logError(GError.missingTotalCount)
            return nil
        }
        return total
    }

    static func getTotalVotingPower(from headers: HttpHeaders) -> Double? {
        guard let totalStr = headers["x-total-vp"] as? String,
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

    static func shortDateWithoutTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }

    static func monthAndYear(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
    
    static func monthAndDayAndYear(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }

    static func formatDateToStartOfMonth(_ date: Date, day: Int = 1) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month], from: date)
        components.timeZone = .gmt
        components.day = day
        return calendar.date(from: components)!
    }

    static func formatDateToStartOfDay(_ date: Date, hour: Int = 0) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.timeZone = .gmt
        components.hour = hour
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

    static func heightForDaosRecommendation(count: Int) -> CGFloat {
        switch count {
        case 1: return 300
        case 2: return 420
        case 3: return 540
        default: return 660
        }
    }

    static func choiseAsStr(proposal: Proposal, choice: AnyObject) -> String {
        switch proposal.type {
        case .singleChoice, .basic:
            return proposal.choices[choice as! Int]

        case .approval:
            let approvedIndices = choice as! [Int]
            let first = proposal.choices[approvedIndices.first!]
            return approvedIndices.dropFirst().reduce(first) { r, i in "\(r), \(proposal.choices[i])" }

        case .rankedChoice:
            let approvedIndices = choice as! [Int]
            let first = proposal.choices[approvedIndices.first!]
            var idx = 1
            return approvedIndices.dropFirst().reduce("(\(idx)) \(first)") { r, i in
                idx += 1
                return "\(r), (\(idx)) \(proposal.choices[i])"
            }

        case .weighted, .quadratic:
            let choicesPower = choice as! [String: Double]
            let totalPower = choicesPower.values.reduce(0, +)

            // to keep them sorted we will use proposal choices array
            let choices = proposal.choices.indices.filter {
                if let value = choicesPower[String($0 + 1)] {
                    return value != 0
                }
                return false
            }
            let first = choices.first!
            let firstPercentage = Utils.percentage(of: choicesPower[String(first + 1)]!, in: totalPower)
            return choices.dropFirst().reduce("\(firstPercentage) for \(first + 1)") { r, k in
                let percentage = Utils.percentage(of: choicesPower[String(k + 1)]!, in: totalPower)
                return "\(r), \(percentage) for \(k + 1)"
            }
        }
    }

    static func userChoice(from proposal: Proposal) -> AnyObject? {
        // TODO: shutter completed proposals results are known. Need to improve.
        guard let vote = proposal.userVote, proposal.privacy != .shutter else { return nil }
        return castAnyVoteToAnyObject(vote, proposalType: proposal.type)
    }

    static func publicUserChoice(from proposal: Proposal) -> AnyObject? {
        guard let vote = proposal.publicUserVote, proposal.privacy != .shutter else { return nil }
        return castAnyVoteToAnyObject(vote, proposalType: proposal.type)
    }

    private static func castAnyVoteToAnyObject(_ vote: Proposal.AnyVote, proposalType: Proposal.ProposalType) -> AnyObject? {
        // enumeration starts with 1 in Snapshot
        switch proposalType {
        case .singleChoice, .basic:
            return (vote.base as! Vote<Int>).choice - 1 as AnyObject
        case .approval, .rankedChoice:
            return (vote.base as! Vote<[Int]>).choice.map { $0 - 1 } as AnyObject
        case .weighted, .quadratic:
            return (vote.base as! Vote<[String: Double]>).choice as AnyObject
        }
    }
}
