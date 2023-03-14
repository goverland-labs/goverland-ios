//
//  DaoInfoScreenHeaderView().swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-07.
//

import SwiftUI

struct DaoInfoScreenHeaderView: View {
    
    let event: ActivityEvent
    
    var body: some View {
        HStack {
            DaoPictureView(daoImage: event.daoImage, imageSize: 100)
            HStack {
                InfoBadgeView(value: "103", title: "Proposales")
                InfoBadgeView(value: "342.9K", title: "Holders")
                InfoBadgeView(value: "$2.8B", title: "Treasury")
            }
            .scaledToFill()
            .minimumScaleFactor(0.5)
            .lineLimit(1)
        }
    }
}

fileprivate struct InfoBadgeView: View {
    let value: String
    let title: String
    var body: some View {
        VStack {
            Text(value)
                .fontWeight(.semibold)
            Text(title)
        }
    }
    
}

struct DaoInfoScreenHeaderViewPreviews: PreviewProvider {
    static var previews: some View {
        DaoInfoScreenHeaderView(event: ActivityEvent(
            id: UUID(),
            user: User(
                address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                image: URL(string: ""),
                name: "safe1.sche.eth"),
            date: Date(),
            type: .discussion,
            status: .discussion,
            content: ActivityViewContent(title: "title", subtitle: "subtitle", warningSubtitle: "warningSubtitle"),
            daoImage: URL(string: ""),
            meta: ActivityEventsVoteMeta(voters: 1, quorum: "1", voted: true)))
    }
}
