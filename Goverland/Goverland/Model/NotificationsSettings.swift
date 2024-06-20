//
//  NotificationsSettings.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 09.07.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation

struct NotificationsSettings: Codable {
    let daoSettings: NotificationsDaoSettings

    struct NotificationsDaoSettings: Codable {
        let newProposalCreated: Bool
        let quorumReached: Bool
        let voteFinishesSoon: Bool
        let voteFinished: Bool

        enum CodingKeys: String, CodingKey {
            case newProposalCreated = "new_proposal_created"
            case quorumReached = "quorum_reached"
            case voteFinishesSoon = "vote_finishes_soon"
            case voteFinished = "vote_finished"
        }

        func with(newProposalCreated: Bool? = nil,
                  quorumReached: Bool? = nil,
                  voteFinishesSoon: Bool? = nil,
                  voteFinished: Bool? = nil) -> NotificationsDaoSettings {
            NotificationsDaoSettings(newProposalCreated: newProposalCreated ?? self.newProposalCreated,
                                     quorumReached: quorumReached ?? self.quorumReached,
                                     voteFinishesSoon: voteFinishesSoon ?? self.voteFinishesSoon,
                                     voteFinished: voteFinished ?? self.voteFinished)
        }
    }

    enum CodingKeys: String, CodingKey {
        case daoSettings = "dao"
    }
}
