//
//  ActivityView.swift
//  DaoFeed
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct ActivityView: View {
    
    var events: [ActivityEvent] = TestActivityEventsData.data.getEvents()
    
    var body: some View {
        
        List {
            ForEach(events) { event in
                
                ActivityListItemView(event: event)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init(top: 10, leading: 15, bottom: 20, trailing: 15))
            }
        }
        
    }
}









// TODO: Move to models

class TestActivityEventsData {
    
    static let data = TestActivityEventsData()
    var events: [ActivityEvent] = []
    
    private init() {
        
        let eventVoteActiveVote = ActivityEvent(
            user: User(
                address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                image: "https://cdn-icons-png.flaticon.com/512/17/17004.png?w=1060&t=st=1672407609~exp=1672408209~hmac=7cb92bf848bb316a8955c5f510ce50f48c6a9484fb3641fa70060c212c2a8e39",
                name: "kris.eth"),
            date: Date(),
            type: .vote,
            status: .activeVote,
            content: ActivityViewContent(
                title: "UIP23 - DAO Operations Buget",
                subtitle: "2 days left to vote via Snapshot",
                warningSubtitle: nil),
            meta: ["239", "105%", ""])
        
        let eventDiscussionDiscussion = ActivityEvent(
            user: User(
                address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                image: "https://cdn-icons-png.flaticon.com/512/17/17004.png?w=1060&t=st=1672407609~exp=1672408209~hmac=7cb92bf848bb316a8955c5f510ce50f48c6a9484fb3641fa70060c212c2a8e39",
                name: "uniman_ETH1f99999999999"),
            date: Date(),
            type: .discussion,
            status: .discussion,
            content: ActivityViewContent(
                title: "Deploy Uniswap V3 to Boba Layer 2 Network",
                subtitle: "2 days left to vote vs snapshot",
                warningSubtitle: nil),
            meta: ["239", "342", "12"])
        
        let eventVoteQueued = ActivityEvent(
            user: User(
                address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                image: "https://cdn-icons-png.flaticon.com/512/17/17004.png?w=1060&t=st=1672407609~exp=1672408209~hmac=7cb92bf848bb316a8955c5f510ce50f48c6a9484fb3641fa70060c212c2a8e39",
                name: nil),
            date: Date(),
            type: .vote,
            status: .queued,
            content: ActivityViewContent(
                title: "UIP19 - DAO Operations",
                subtitle: "Snapshot voting ended  3 days ago",
                warningSubtitle: "Waiting for execution"),
            meta: ["132", "124%", ""])
    
        let eventVoteExecuted = ActivityEvent(
            user: User(
                address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                image: "https://cdn-icons-png.flaticon.com/512/17/17004.png?w=1060&t=st=1672407609~exp=1672408209~hmac=7cb92bf848bb316a8955c5f510ce50f48c6a9484fb3641fa70060c212c2a8e39",
                name: nil),
            date: Date(),
            type: .vote,
            status: .executed,
            content: ActivityViewContent(
                title: "UIP18 - Fee mechanism",
                subtitle: "Executed 1 day ago",
                warningSubtitle: nil),
            meta: ["593", "121%", "voted"])
        
        let eventVoteFailed = ActivityEvent(
            user: User(
                address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                image: "https://cdn-icons-png.flaticon.com/512/17/17004.png?w=1060&t=st=1672407609~exp=1672408209~hmac=7cb92bf848bb316a8955c5f510ce50f48c6a9484fb3641fa70060c212c2a8e39",
                name: nil),
            date: Date(),
            type: .vote,
            status: .failed,
            content: ActivityViewContent(
                title: "UIP17 - Updated terms & conditions",
                subtitle: "Failed 1 day ago: Quorum not reached",
                warningSubtitle: nil),
            meta: ["22", "54%", "voted"])

        
        events.append(eventVoteActiveVote)
        events.append(eventDiscussionDiscussion)
        events.append(eventVoteQueued)
        events.append(eventVoteExecuted)
        events.append(eventVoteFailed)
        
    }
    
    func getEvents() -> [ActivityEvent] {
        return events
    }
    
}

struct User {
    
    private(set) var address: String
    private(set) var endsName: String?
    private(set) var image: String
    
    init(address: String, image: String, name: String?) {
        self.address = address
        self.endsName = name
        self.image = image
    }
}

struct ActivityEvent: Identifiable {
    
    private(set) var id: UUID
    private(set) var user: User
    private(set) var date: Date
    private(set) var type: ActivityListItemType
    private(set) var status: ActivityListItemStatus
    private(set) var content: ActivityViewContent
    private(set) var meta: [String]
    
    init(user: User, date: Date, type: ActivityListItemType, status: ActivityListItemStatus, content: ActivityViewContent, meta: [String]) {
        self.id = UUID()
        self.user = user
        self.date = date
        self.type = type
        self.status = status
        self.content = content
        self.meta = meta
    }
}

struct ActivityViewContent {
    
    private(set) var title: String
    private(set) var subtitle: String
    private(set) var warningSubtitle: String?
    
    init(title: String, subtitle: String, warningSubtitle: String?) {
        self.title = title
        self.subtitle = subtitle
        self.warningSubtitle = warningSubtitle
    }
}

enum ActivityListItemType {
    case vote
    case discussion
    case undefined
}

enum ActivityListItemStatus {
    case discussion
    case activeVote
    case executed
    case failed
    case queued
    case succeeded
    case defeated
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
