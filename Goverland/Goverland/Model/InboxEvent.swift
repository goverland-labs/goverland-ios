//
//  InboxEvent.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-06.
//

import SwiftUI
import Combine

struct InboxEvent: Identifiable, Decodable {
    
    let id: UUID
    let user: User
    let date: Date
    let type: InboxEventType
    let status: InboxEventStatus
    let content: InboxViewContent
    let daoImage: URL?
    let meta: InboxEventMetaInfo?
    
    init(id: UUID,
         user: User,
         date: Date,
         type: InboxEventType,
         status: InboxEventStatus,
         content: InboxViewContent,
         daoImage: URL?,
         meta: InboxEventMetaInfo?) {
        self.id = id
        self.user = user
        self.date = date
        self.type = type
        self.status = status
        self.content = content
        self.daoImage = daoImage
        self.meta = meta
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case user
        case date
        case type
        case status
        case content
        case daoImage
        case meta
    }
    
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.user = try container.decode(User.self, forKey: .user)
        self.date = try container.decode(Date.self, forKey: .date)
        self.type = try container.decode(InboxEventType.self, forKey: .type)
        self.status = try container.decode(InboxEventStatus.self, forKey: .status)
        self.content = try container.decode(InboxViewContent.self, forKey: .content)
        self.daoImage = try container.decode(URL.self, forKey: .daoImage)
        switch type {
        case .vote:
            self.meta = try? container.decode(InboxEventsVoteMeta.self, forKey: .meta)
        case .discussion:
            self.meta = try? container.decode(InboxEventsDiscussionMeta.self, forKey: .meta)
        }
        
    }
}

protocol InboxEventMetaInfo {}

struct InboxEventsVoteMeta: InboxEventMetaInfo, Decodable {
    
    let voters: Int
    let quorum: String
    let voted: Bool
    
    init(voters: Int, quorum: String, voted: Bool) {
        self.voters = voters
        self.quorum = quorum
        self.voted = voted
    }
}

struct InboxEventsDiscussionMeta: InboxEventMetaInfo, Decodable {
    
    let comments: Int
    let views: Int
    let participants: Int
    
    init(comments: Int, views: Int, participants: Int) {
        self.comments = comments
        self.views = views
        self.participants = participants
    }
}

enum InboxEventType: String, Decodable {
    case vote
    case discussion
}

enum InboxEventStatus: String, Decodable {
    case discussion
    case activeVote
    case executed
    case failed
    case queued
    case succeeded
    case defeated
}

enum FilterType: Int, Identifiable {
    var id: Int { self.rawValue }
    
    case all = 0
    case vote
    case treasury
    
    static var allFilters: [FilterType] {
        return [.all, .vote, .treasury]
    }
    
    var localizedName: String {
        switch self {
        case .all:
            return "All"
        case .vote:
            return "Vote"
        case .treasury:
            return "Treasury"
        }
    }
}

struct InboxViewContent: Decodable {
    
    let title: String
    let subtitle: String
    let warningSubtitle: String?
    
    init(title: String, subtitle: String, warningSubtitle: String?) {
        self.title = title
        self.subtitle = subtitle
        self.warningSubtitle = warningSubtitle
    }
}
