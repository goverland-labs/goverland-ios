//
//  ActivityEvent.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2023-01-06.
//

import SwiftUI

struct ActivityEvent: Identifiable, Decodable {
    
    let id: String
    let user: User
    let date: String
    let type: ActivityEventType
    let status: ActivityEventStatus
    let content: ActivityViewContent
    let daoImage: String
    let meta: [String]
    
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
    
    init(id: String, user: User, date: String, type: ActivityEventType, status: ActivityEventStatus, content: ActivityViewContent, daoImage: String, meta: [String]) {
        self.id = id
        self.user = user
        self.date = date
        self.type = type
        self.status = status
        self.content = content
        self.daoImage = daoImage
        self.meta = meta
    }
    
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.user = try container.decode(User.self, forKey: .user)
        self.date = try container.decode(String.self, forKey: .date)
        self.type = try container.decode(ActivityEventType.self, forKey: .type)
        self.status = try container.decode(ActivityEventStatus.self, forKey: .status)
        self.content = try container.decode(ActivityViewContent.self, forKey: .content)
        self.daoImage = try container.decode(String.self, forKey: .daoImage)
        self.meta = try container.decode([String].self, forKey: .meta)
    }
}

enum ActivityEventType: String, Codable {
    case vote
    case discussion
    case undefined
}

enum ActivityEventStatus: String, Codable {
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
