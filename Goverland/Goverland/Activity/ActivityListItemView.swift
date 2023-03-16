//
//  ActivityListItemView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-28.
//

import SwiftUI

struct ActivityListItemView: View {
    
    var event: ActivityEvent

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color("white-darkGray"))
                .padding(.horizontal, -12)
            
            VStack(spacing: 15) {
                ActivityListItemHeaderView(event: event)
                ActivityListItemBodyView(event: event)
                ActivityListItemFooterView(event: event)
            }
        }
    }
}

struct ActivityListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListItemView(event: ActivityEvent(
            id: UUID(),
            user: User(
                address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                image: URL(string: ""),
                name: "safe1.sche.eth"),
            date: Date(),
            type: .discussion,
            status: .discussion,
            content: ActivityViewContent(title: "", subtitle: "", warningSubtitle: ""),
            daoImage: URL(string: ""),
            meta: ActivityEventsVoteMeta(voters: 1, quorum: "1", voted: true)))
    }
}
