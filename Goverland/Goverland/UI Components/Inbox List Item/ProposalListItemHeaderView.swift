//
//  ProposalListItemHeaderView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI
import SwiftDate

struct ProposalListItemHeaderView: View {
    var event: InboxEvent
    
    var body: some View {
        HStack {
            HStack(spacing: 6) {
                IdentityView(user: event.user)
                DateView(date: event.date)
            }

            Spacer()
            
            HStack(spacing: 6) {
                ReadIndicatiorView()
                StatusView(status: event.status)
            }
        }
    }
}

fileprivate struct ReadIndicatiorView: View {
    var body: some View {
        Circle()
            .fill(.primary)
            .frame(width: 4, height: 4)
    }
}



struct ListItemHeader_Previews: PreviewProvider {
    static var previews: some View {
        ProposalListItemHeaderView(event: InboxEvent(
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
