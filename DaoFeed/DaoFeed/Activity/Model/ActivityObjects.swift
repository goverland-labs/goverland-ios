//
//  ActivityObjects.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2023-01-05.
//

import SwiftUI

struct User {
    
    let address: String
    let ensName: String?
    let image: String
    
    init(address: String, image: String, name: String?) {
        self.address = address
        self.ensName = name
        self.image = image
    }
}

struct ActivityEvent: Identifiable {
    
    let id: UUID
    let user: User
    let date: Date
    let type: ActivityListItemType
    let status: ActivityListItemStatus
    let content: ActivityViewContent
    let daoImage: String
    let meta: [String]
    
    init(user: User, date: Date, type: ActivityListItemType, status: ActivityListItemStatus, content: ActivityViewContent, daoImage: String, meta: [String]) {
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

