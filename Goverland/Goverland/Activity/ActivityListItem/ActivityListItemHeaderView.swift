//
//  ActivityListItemHeaderView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI
import SwiftDate

struct ActivityListItemHeaderView: View {
    
    var event: ActivityEvent
    
    var body: some View {
        
        HStack {
            UserPictureView(userImage: event.user.image, imageSize: 15)

            ActivityListItemHeaderUserView(event: event)

            Text(event.date.toRelative(since: DateInRegion()))
                .foregroundColor(.gray)

            Spacer()

            ActivityListItemStatusBubbleView(event: event)
        }
    }
}

fileprivate struct ActivityListItemHeaderUserView: View {
    
    var event: ActivityEvent
    
    var body: some View {
        
        if let name = event.user.ensName {
            Text(name)
                .fontWeight(.semibold)
                .lineLimit(1)
        } else {
            Text(event.user.address)
                .fontWeight(.semibold)
                .lineLimit(1)
                .truncationMode(.middle)
        }
    }
}

fileprivate struct ActivityListItemStatusBubbleView: View {
    
    var event: ActivityEvent
    
    var body: some View {
        
        switch event.status {
        
        case .discussion:
            ListItemBubbleView(
                image: Image(systemName: "bubble.left.and.bubble.right"),
                text: Text("DISCUSSION"),
                backgroundColor: Color.gray)
        
        case .activeVote:
            ListItemBubbleView(
                image: Image(systemName: "plus"),
                text: Text("ACTIVE VOTE"),
                backgroundColor: Color.blue)
        
        case .executed:
            ListItemBubbleView(
                image: Image(systemName: "checkmark"),
                text: Text("EXECUTED"),
                backgroundColor: Color.green)
        
        case .failed:
            ListItemBubbleView(
                image: Image(systemName: "xmark"),
                text: Text("FAILED"),
                backgroundColor: Color.red)
        
        case .queued:
            ListItemBubbleView(
                image: nil,
                text: Text("QUEUED"),
                backgroundColor: Color.yellow)
            
        case .succeeded:
            ListItemBubbleView(
                image: nil,
                text: Text("SUCCEEDE"),
                backgroundColor: Color.green)
        
        case .defeated:
            ListItemBubbleView(
                image: Image(systemName: ""),
                text: Text("DEFEATED"),
                backgroundColor: Color.pink)
        }
    }
}

fileprivate struct ListItemBubbleView: View {
    
    var image: Image?
    var text: Text
    var backgroundColor: Color
    
    var body: some View {
        HStack(spacing: 3) {
            image
                .font(.system(size: 9))
                .foregroundColor(.white)
            
            text
                .font(.system(size: 12))
                .foregroundColor(.white)
                .fontWeight(.bold)
                .minimumScaleFactor(0.1)
                .lineLimit(1)
        }
        .padding([.leading, .trailing], 9)
        .padding([.top, .bottom], 5)
        .background(Capsule().fill(backgroundColor))
    }
}

struct ListItemHeader_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListItemHeaderView(event: ActivityEvent(
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
