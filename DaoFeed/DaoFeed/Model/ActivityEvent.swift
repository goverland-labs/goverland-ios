//
//  ActivityEvent.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2023-01-06.
//

import SwiftUI

struct ActivityEvent: Identifiable {
    
    let id: UUID
    let user: User
    let date: Date
    let type: ActivityEventType
    let status: ActivityEventStatus
    let content: ActivityViewContent
    let daoImage: String
    let meta: [String]
    
    init(user: User, date: Date, type: ActivityEventType, status: ActivityEventStatus, content: ActivityViewContent, daoImage: String, meta: [String]) {
        self.id = UUID()
        self.user = user
        self.date = date
        self.type = type
        self.status = status
        self.content = content
        self.daoImage = daoImage
        self.meta = meta
    }
}

enum ActivityEventType {
    case vote
    case discussion
    case undefined
}

enum ActivityEventStatus {
    case discussion
    case activeVote
    case executed
    case failed
    case queued
    case succeeded
    case defeated
}

struct ActivityViewContent {
    
    let title: String
    let subtitle: String
    let warningSubtitle: String?
    
    init(title: String, subtitle: String, warningSubtitle: String?) {
        self.title = title
        self.subtitle = subtitle
        self.warningSubtitle = warningSubtitle
    }
}
