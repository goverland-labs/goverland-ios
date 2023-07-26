//
//  GError.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 12.07.23.
//

import Foundation

enum GError: Error {
    case missingTotalCount
    case missingUnreadCount
    case missingSubscriptionsCount
    case indexOutOfRange

    var localizedDescription: String {
        switch self {
        case .missingTotalCount:
            return "Missing x-total-count."
        case .missingUnreadCount:
            return "Missing x-unread-count."
        case .missingSubscriptionsCount:
            return "Missing x-subscriptions-count."
        case .indexOutOfRange:
            return "Index out of range"
        }
    }
}
