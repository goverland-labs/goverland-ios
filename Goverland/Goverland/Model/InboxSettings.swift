//
//  InboxSettings.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 01.07.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct InboxSettings: Codable {
    let archiveProposalAfterVote: Bool
    let autoarchiveAfter: Timeframe

    enum Timeframe: String, Codable, CaseIterable {
        case oneDay = "1d"
        case threeDays = "3d"
        case oneWeek = "7d"
        case oneMonth = "30d"

        var localizedDescription: String {
            switch self {
            case .oneDay: "1 day"
            case .threeDays: "3 days"
            case .oneWeek: "1 week"
            case .oneMonth: "1 month"
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case archiveProposalAfterVote = "archive_proposal_after_vote"
        case autoarchiveAfter = "autoarchive_after"
    }

    func with(archiveProposalAfterVote: Bool? = nil,
              autoarchiveAfter: Timeframe? = nil) -> InboxSettings {
        InboxSettings(archiveProposalAfterVote: archiveProposalAfterVote ?? self.archiveProposalAfterVote,
                                  autoarchiveAfter: autoarchiveAfter ?? self.autoarchiveAfter)
    }
}
