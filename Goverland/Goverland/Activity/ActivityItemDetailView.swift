//
//  ActivityItemDetailView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-18.
//

import SwiftUI

struct ActivityItemDetailView: View {
    
    var event: ActivityEvent
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                ActivityDetailHeaderView()
                ActivityDetailStatusRowView()
                ActivityDetailSummaryView()
                ActivityDetailForumView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Uniswap DAO")
        .padding()
    }
}

struct ActivityItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityItemDetailView(event: ActivityEvent(
            id: UUID(),
            user: User(
                address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                image: "https://cdn-icons-png.flaticon.com/512/17/17004.png?w=1060&t=st=1672407609~exp=1672408209~hmac=7cb92bf848bb316a8955c5f510ce50f48c6a9484fb3641fa70060c212c2a8e39",
                name: "safe1.sche.eth"),
            date: Date(),
            type: .discussion,
            status: .discussion,
            content: ActivityViewContent(title: "title", subtitle: "subtitle", warningSubtitle: "warningSubtitle"),
            daoImage: "",
            meta: ActivityEventsVoteMeta(voters: 1, quorum: "1", voted: true)))
    }
}
