//
//  InboxDetailForumView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-18.
//

import SwiftUI

struct InboxDetailForumView: View {
    let event: InboxEvent
    var body: some View {
        HStack {
            Button(action: openDiscussionForum) {
                DaoPictureView(daoImage: event.daoImage, imageSize: 40)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("View forum discussion")
                        .fontWeight(.semibold)
                        
                    
                    HStack(spacing: 3) {
                        Image(systemName: "ellipsis.message.fill")
                            .foregroundColor(.gray)
                        Text("21")
                            .foregroundColor(.primary)
                        Text("comments")
                            .foregroundColor(.primary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.forward")
                    .foregroundColor(.gray)
            }
            .padding(10)
            .background(Color("lightGray-darkGray"))
            .cornerRadius(10)
        }
    }
    
    private func openDiscussionForum() {}
}

struct InboxDetailForumView_Previews: PreviewProvider {
    static var previews: some View {
        InboxDetailForumView(event: InboxEvent(
            id: UUID(),
            user: User(
                address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                image: URL(string: ""),
                name: "safe1.sche.eth"),
            date: Date(),
            type: .discussion,
            status: .discussion,
            content: InboxViewContent(title: "title", subtitle: "subtitle", warningSubtitle: "warningSubtitle"),
            daoImage: URL(string: ""),
            meta: InboxEventsVoteMeta(voters: 1, quorum: "1", voted: true)))
    }
}
