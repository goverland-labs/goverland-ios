//
//  InboxNotificationSettings.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 01.07.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct InboxNotificationSettings: Codable {
    let archiveProposalAfterVote: Bool
    let autoarchiveAfter: Timeframe

    enum Timeframe: String, Codable {
        case oneDay = "1d"
        case threeDays = "3d"
        case oneWeek = "1w"
        case oneMonth = "1m"
    }

    enum CodingKeys: String, CodingKey {
        case archiveProposalAfterVote = "archive_proposal_after_vote"
        case autoarchiveAfter = "autoarchive_after"
    }
}
