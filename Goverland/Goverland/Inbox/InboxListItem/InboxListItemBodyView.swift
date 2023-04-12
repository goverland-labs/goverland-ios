//
//  InboxListItemBodyView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct InboxListItemBodyView: View {
    var event: InboxEvent
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(event.content.title)
                    .foregroundColor(.goverlandInboxListItemTitleText)
                    .fontWeight(.semibold)
                    .font(.system(size: 15))
                    .lineLimit(2)
                
                Text(event.content.subtitle)
                    .foregroundColor(.goverlandInboxListItemSubtitleText)
                    .fontWeight(.regular)
                    .font(.system(size: 13))
                    .lineLimit(1)
                
                if let warning = event.content.warningSubtitle {
                    Text(warning)
                        .foregroundColor(.goverlandInboxListItemWarningText)
                        .fontWeight(.regular)
                        .font(.system(size: 13))
                        .lineLimit(1)
                } else {
                    Text("")
                }
            }
            
            Spacer()
            
            DaoPictureView(daoImage: event.daoImage, imageSize: 46)
        }
    }
}

struct ListItemBody_Previews: PreviewProvider {
    static var previews: some View {
        InboxListItemBodyView(event: InboxEvent(
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
