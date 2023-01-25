//
//  ActivityEvent.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2023-01-06.
//

import SwiftUI
import Combine

struct ActivityEvent: Identifiable, Decodable {
    
    let id: UUID
    let user: User
    let date: Date
    let type: ActivityEventType
    let status: ActivityEventStatus
    let content: ActivityViewContent
    let daoImage: String
    let meta: ActivityEventMetaInfo?
    
    init(id: UUID,
         user: User,
         date: Date,
         type: ActivityEventType,
         status: ActivityEventStatus,
         content: ActivityViewContent,
         daoImage: String,
         meta: ActivityEventMetaInfo?) {
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
        self.type = try container.decode(ActivityEventType.self, forKey: .type)
        self.status = try container.decode(ActivityEventStatus.self, forKey: .status)
        self.content = try container.decode(ActivityViewContent.self, forKey: .content)
        self.daoImage = try container.decode(String.self, forKey: .daoImage)
        
        switch type {
        case .vote:
            self.meta = try container.decode(ActivityEventsVoteMeta.self, forKey: .meta)
        case .discussion:
            self.meta = try container.decode(ActivityEventsDiscussionMeta.self, forKey: .meta)
        case .undefined:
            self.meta = try container.decode(ActivityEventsVoteMeta.self, forKey: .meta)
        }
    }
}

protocol ActivityEventMetaInfo {}

struct ActivityEventsVoteMeta: ActivityEventMetaInfo, Decodable {
    
    let voters: Int
    let quorum: String
    let voted: Bool
    
    init(voters: Int, quorum: String, voted: Bool) {
        self.voters = voters
        self.quorum = quorum
        self.voted = voted
    }
}

struct ActivityEventsDiscussionMeta: ActivityEventMetaInfo, Decodable {
    
    let comments: Int
    let views: Int
    let participants: Int
    
    init(comments: Int, views: Int, participants: Int) {
        self.comments = comments
        self.views = views
        self.participants = participants
    }
}

enum ActivityEventType: String, Decodable {
    case vote
    case discussion
    case undefined
}

enum ActivityEventStatus: String, Decodable {
    case discussion
    case activeVote
    case executed
    case failed
    case queued
    case succeeded
    case defeated
}

enum FilterType {
    case all
    case discussion
    case vote
}

struct ActivityViewContent: Decodable {
    
    let title: String
    let subtitle: String
    let warningSubtitle: String?
    
    init(title: String, subtitle: String, warningSubtitle: String?) {
        self.title = title
        self.subtitle = subtitle
        self.warningSubtitle = warningSubtitle
    }
}
