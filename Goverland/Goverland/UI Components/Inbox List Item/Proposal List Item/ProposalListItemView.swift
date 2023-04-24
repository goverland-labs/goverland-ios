//
//  ProposalListItemView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-28.
//

import SwiftUI

struct ProposalListItemView: View {
    @State private var isRead = false
    var event: InboxEvent

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.container)
            
            VStack(spacing: 15) {
                ProposalListItemHeaderView(user: event.user, date: event.date, status: event.status)
                ProposalListItemBodyView(content: event.content, daoImage: event.daoImage)
                ProposalListItemFooterView(meta: event.meta)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
        }
    }
}

struct InboxListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ProposalListItemView(event: InboxEvent(
            id: UUID(),
            user: User.flipside,
            date: Date(),
            type: .discussion,
            status: .discussion,
            content: InboxViewContent(title: "", subtitle: "", warningSubtitle: ""),
            daoImage: URL(string: ""),
            meta: InboxEventsVoteMeta(voters: 1, quorum: "1", voted: true)))
    }
}
