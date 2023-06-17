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

// TODO: rework, WIP
enum Event: String, Decodable {
    case proposalCreated
    case proposalUpdated

    enum CodingKeys: String, CodingKey {
        case proposalCreated = "proposal_created"
        case proposalUpdated = "proposal_updated"
    }

    var isProposal: Bool {
        true
    }
}

struct InboxEvent: Identifiable, Decodable {
    let id: UUID
    let createdAt: Date
    let updatedAt: Date
    let readAt: Date?
    let event: Event?
    let eventData: EventData?
    
    init(id: UUID,
         createdAt: Date,
         updatedAt: Date,
         readAt: Date?,
         event: Event?,
         eventData: EventData?) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.readAt = readAt
        self.event = event
        self.eventData = eventData
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case readAt = "read_at"
        case event
        case proposal
    }
    
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(UUID.self, forKey: .id)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.readAt = try container.decode(Date?.self, forKey: .readAt)
        self.event = try? container.decode(Event?.self, forKey: .event)
        if let event = event {
            print("Event: \(event)")
            self.eventData = try container.decode(Proposal?.self, forKey: .proposal)
        } else {
            self.eventData = nil
        }
    }
}

// MARK: - Mock data

extension InboxEvent {
    static let vote1 = InboxEvent(
        id: UUID(uuidString: "d4a04089-a6b4-448f-b85d-37c7e975cbd9")!,
        createdAt: .now - 5.days,
        updatedAt: .now - 3.days,
        readAt: nil,
        event: .proposalCreated,
        eventData: Proposal.aaveTest)
}
