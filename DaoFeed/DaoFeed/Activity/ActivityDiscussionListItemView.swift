//
//  DiscussionListView.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct ActivityDiscussionListItemView: View {
    
    var event: ActivityEvent
    
    var body: some View {
        
        VStack(spacing: 20) {
            ActivityListItemHeaderView(event: event)
            ActivityListItemBodyView(event: event)
            ActivityListItemFooterView(event: event)
        }
    }
}

struct DiscussionListView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDiscussionListItemView(event: ActivityEvent(
            user: User(
                address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                image: "https://example.org/image.jpg",
                name: "safe1.sche.eth"),
            date: Date(),
            type: .discussion,
            status: .discussion,
            content: ActivityViewContent(title: "", subtitle: "", warningSubtitle: ""),
            daoImage: "",
            meta: ["", "", ""]))
    }
}
