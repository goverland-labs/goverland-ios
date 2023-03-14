//
//  ActivityListItemBodyView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct ActivityListItemBodyView: View {
    
    var event: ActivityEvent
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 5) {
                
                Text(event.content.title)
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .lineLimit(2)
                
                Text(event.content.subtitle)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                if let warning = event.content.warningSubtitle {
                    Text(warning)
                        .foregroundColor(.yellow)
                        .lineLimit(2)
                } else {
                    Text("")
                }
            }
            
            Spacer()
            
            DaoPictureView(daoImage: event.daoImage, imageSize: 50)
        }
    }
}

struct ListItemBody_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListItemBodyView(event: ActivityEvent(
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
