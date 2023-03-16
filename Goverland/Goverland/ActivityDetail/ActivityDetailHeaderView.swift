//
//  ActivityDetailHeader.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-18.
//

import SwiftUI

struct ActivityDetailHeaderView: View {
    
    let event: ActivityEvent
    
    var body: some View {
        HStack(spacing: 12) {
            DaoPictureView(daoImage: event.daoImage, imageSize: 50)
            Text("Deplay Uniswap V3 on StarkNet")
                .fontWeight(.semibold)
            Spacer()
        }
    }
}

struct ActivityDetailHeader_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailHeaderView(event: ActivityEvent(
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
