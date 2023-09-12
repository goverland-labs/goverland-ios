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
    case voteResultsInconsistency(id: String)
    case failedVotesDecoding(proposalID: String)

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
        }
    }
}
