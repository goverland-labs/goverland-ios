//
//  GError.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 12.07.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation

enum GError: Error {
    case missingTotalCount
    case missingUnreadCount
    case missingSubscriptionsCount
    case voteResultsInconsistency(id: String)
    case failedVotesDecoding(proposalID: String)
    case appInconsistency(reason: String)
    case errorDecodingData(error: Error, context: String)

    var localizedDescription: String {
        switch self {
        case .missingTotalCount:
            return "Missing x-total-count."
        case .missingUnreadCount:
            return "Missing x-unread-count."
        case .missingSubscriptionsCount:
            return "Missing x-subscriptions-count."
        case .voteResultsInconsistency(let id):
            return "Index out of range for proposal id: \(id)"
        case .failedVotesDecoding(let proposalID):
            return "Could not decode votes for proposal \(proposalID)"
        case .appInconsistency(let reason):
            return "App inconsistency: \(reason)"
        case .errorDecodingData(let error, let context):
            return "Error decoding data: \(error.localizedDescription); Context: \(context)"
        }
    }
}
