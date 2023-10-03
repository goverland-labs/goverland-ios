//
//  ConfigurationManager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.07.23.
//

import Foundation

class ConfigurationManager {
    enum ConfigKeys: String {
        case baseURL = "BASE_URL"
        case wcProjectId = "WC_PROJECT_ID"
        case defaultPaginationCount = "DEFAULT_PAGINATION_COUNT"
        case timeout = "TIMEOUT"
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

    static var wcProjectId: String {
        return self.value(for: .wcProjectId)        
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
}
