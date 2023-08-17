//
//  InboxEvent.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-06.
//

import Foundation
import SwiftDate

protocol EventData {}

extension Proposal: EventData {}

struct TimelineEvent: Decodable {
    let createdAt: Date
    let event: Event

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case event
    }
}

enum Event: String, Decodable {
    case daoCreated = "dao.created"

    case proposalCreated = "proposal.created"
    case proposalUpdated = "proposal.updated"
    case proposalUpdatedState = "proposal.updated.state"
    case proposalVotingStartsSoon = "proposal.voting.starts_soon"
    case proposalVotingStarted = "proposal.voting.started"
    case proposalVotingReachedQuorum = "proposal.voting.quorum_reached"
    case proposalVoringFinishesSoon = "proposal.voting.coming"
    case proposalVotingEndsSoon = "proposal.voting.ends_soon"
    case proposalVotingEnded = "proposal.voting.ended"
    
    var localizedName: String {
        switch self {
        case .daoCreated: return "DAO created"
        case .proposalCreated: return "Proposal vote created"
        case .proposalUpdated: return "Proposal vote updated"
        case .proposalUpdatedState: return "Proposal vote state updated"
        case .proposalVotingStarted :return "Proposal vote started"
        case .proposalVotingStartsSoon :return "Proposal vote will start soon"
        case .proposalVotingReachedQuorum :return "Proposal vote reached quorum"
        case .proposalVoringFinishesSoon :return "Proposal vote is coming"
        case .proposalVotingEnded :return "Proposal vote ended"
        case .proposalVotingEndsSoon :return "Proposal vote is ending soon"
        }
    }
}

struct InboxEvent: Identifiable, Decodable {
    let id: UUID
    let createdAt: Date
    let updatedAt: Date
    // we change it manually not to reload all data
    var readAt: Date?
    let eventData: EventData?
    let timeline: [TimelineEvent]
    
    init(id: UUID,
         createdAt: Date,
         updatedAt: Date,
         readAt: Date?,
         eventData: EventData?,
         timeline: [TimelineEvent]) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.readAt = readAt
        self.eventData = eventData
        self.timeline = timeline
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case readAt = "read_at"
        case proposal
        case timeline
    }

    // TODO: finalize once API is ready
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.readAt = try container.decodeIfPresent(Date.self, forKey: .readAt)

        do {
            self.eventData = try container.decodeIfPresent(Proposal.self, forKey: .proposal)
        } catch {
            logError(error)            
            self.eventData = nil
        }

        self.timeline = try container.decode([TimelineEvent].self, forKey: .timeline)
    }
}

// MARK: - Mock data

extension InboxEvent {
    static let vote1 = InboxEvent(
        id: UUID(uuidString: "d4a04089-a6b4-448f-b85d-37c7e975cbd9")!,
        createdAt: .now - 5.days,
        updatedAt: .now - 3.days,
        readAt: nil,
        eventData: Proposal.aaveTest,
        timeline: [])
}
