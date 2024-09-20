//
//  ConfigurationManager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.07.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation

class ConfigurationManager {
    enum ConfigKeys: String {
        case baseURL = "BASE_URL"
        case wcProjectId = "WC_PROJECT_ID"
        case defaultPaginationCount = "DEFAULT_PAGINATION_COUNT"
        case timeout = "TIMEOUT"
        case enablePushNotificationsRequestInterval = "ENABLE_PUSH_NOTIFICATIONS_REQUEST_INTERVAL"
        case daoTermsAgreementRequestInterval = "DAO_TERMS_AGREEMENT_REQUEST_INTERVAL"
        case suggestToRateRequestInterval = "SUGGEST_TO_RATE_REQUEST_INTERVAL"
        case hint_AI_summaryRequestInterval = "HINT_AI_SUMMARY_REQUEST_INTERVAL"
    }

    static func value(for key: ConfigKeys) -> String {
        if let value = Bundle.main.infoDictionary?[key.rawValue] as? String {
            return value
        }
        fatalError("Invalid or missing Info.plist key: \(key.rawValue)")
    }

    // - MARK: Networking

    static var baseURL: URL {
        guard let url = URL(string: self.value(for: .baseURL)) else {
            fatalError("Invalid Base URL")
        }
        return url
    }

    static var defaultPaginationCount: Int {
        guard let count = Int(self.value(for: .defaultPaginationCount)) else {
            fatalError("Invalid pagination count")
        }
        return count
    }

    static var timeout: TimeInterval {
        guard let timeout = TimeInterval(self.value(for: .timeout)) else {
            fatalError("Invalid timeout")
        }
        return timeout
    }

    // - MARK: WalletConnect

    static var wcProjectId: String {
        return self.value(for: .wcProjectId)
    }

    // - MARK: Push Notifications

    static var enablePushNotificationsRequestInterval: TimeInterval {
        guard let interval = TimeInterval(self.value(for: .enablePushNotificationsRequestInterval)) else {
            fatalError("Invalid interval")
        }
        return interval
    }

    // - MARK: DAO terms agreement

    static var daoTermsAgreementRequestInterval: TimeInterval {
        guard let interval = TimeInterval(self.value(for: .daoTermsAgreementRequestInterval)) else {
            fatalError("Invalid interval")
        }
        return interval
    }

    // - MARK: Rate the App

    static var suggestToRateRequestInterval: TimeInterval {
        guard let interval = TimeInterval(self.value(for: .suggestToRateRequestInterval)) else {
            fatalError("Invalid interval")
        }
        return interval
    }

    // - MARK: Hint AI summary

    static var hint_AI_summaryRequestInterval: TimeInterval {
        guard let interval = TimeInterval(self.value(for: .hint_AI_summaryRequestInterval)) else {
            fatalError("Invalid interval")
        }
        return interval
    }
}
