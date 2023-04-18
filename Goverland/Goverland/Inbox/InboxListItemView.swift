//
//  InboxListItemView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-28.
//

import SwiftUI

struct InboxListItemView: View {
    @State private var isRead = false
    var event: InboxEvent

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.container)
            
            VStack(spacing: 15) {
                InboxListItemHeaderView(event: event)
                InboxListItemBodyView(event: event)
                InboxListItemFooterView(event: event)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
        }
    }
}

struct InboxListItemView_Previews: PreviewProvider {
    static var previews: some View {
        InboxListItemView(event: InboxEvent(
            id: UUID(),
            user: User(
                address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                image: URL(string: ""),
                name: "safe1.sche.eth"),
            date: Date(),
            type: .discussion,
            status: .discussion,
            content: InboxViewContent(title: "", subtitle: "", warningSubtitle: ""),
            daoImage: URL(string: ""),
            meta: InboxEventsVoteMeta(voters: 1, quorum: "1", voted: true)))
    }
}
