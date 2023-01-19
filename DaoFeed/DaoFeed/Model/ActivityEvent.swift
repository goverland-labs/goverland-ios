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
