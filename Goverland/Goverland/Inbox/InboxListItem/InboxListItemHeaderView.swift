//
//  InboxListItemHeaderView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI
import SwiftDate

struct InboxListItemHeaderView: View {
    
    var event: InboxEvent
    
    var body: some View {
        
        HStack {
            UserPictureView(userImage: event.user.image, imageSize: 15)

            InboxListItemHeaderUserView(event: event)

            InboxListItemDateView(event: event)

            Spacer()
            
            HStack {
                InboxListItemReadIndicatiorView(event: event)
                InboxListItemStatusBubbleView(event: event)
            }
        }
    }
}

fileprivate struct InboxListItemHeaderUserView: View {
    var event: InboxEvent
    
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

fileprivate struct InboxListItemDateView: View {
    var event: InboxEvent
    
    var body: some View {
        Text(event.date.toRelative(since: DateInRegion()))
            .foregroundColor(.gray)
    }
}

fileprivate struct InboxListItemReadIndicatiorView: View {
    var event: InboxEvent
    
    var body: some View {
        Circle()
            .fill(Color.goverlandInboxListItemReadIndicator)
            .frame(width: 4, height: 4)
    }
}

fileprivate struct InboxListItemStatusBubbleView: View {
    var event: InboxEvent
    
    var body: some View {
        
        switch event.status {
        
        case .discussion:
            ListItemBubbleView(
                image: Image(systemName: "bubble.left.and.bubble.right"),
                text: Text("Discussion"),
                textColor: .white,
                backgroundColor: Color.gray)
        
        case .activeVote:
            ListItemBubbleView(
                image: Image(systemName: "bolt.fill"),
                text: Text("Active Vote"),
                textColor: .goverlandStatusPillActiveVoteText,
                backgroundColor: .goverlandStatusPillActiveVoteBackground)
        
        case .executed:
            ListItemBubbleView(
                image: Image(systemName: "checkmark"),
                text: Text("Executed"),
                textColor: .goverlandStatusPillExecutedText,
                backgroundColor: .goverlandStatusPillExecutedBackground)
        
        case .failed:
            ListItemBubbleView(
                image: Image(systemName: "bolt.slash.fill"),
                text: Text("Failed"),
                textColor: .goverlandStatusPillFailedText,
                backgroundColor: .goverlandStatusPillFailedBackground)
        
        case .queued:
            ListItemBubbleView(
                image: Image(systemName: "clock"),
                text: Text("Queued"),
                textColor: .goverlandStatusPillQueuedText,
                backgroundColor: .goverlandStatusPillQueuedBackground)
            
        case .succeeded:
            ListItemBubbleView(
                image: Image(systemName: "checkmark"),
                text: Text("Succeeded"),
                textColor: .goverlandStatusPillSucceededText,
                backgroundColor: .goverlandStatusPillSucceededBackground)
        
        case .defeated:
            ListItemBubbleView(
                image: Image(systemName: "xmark"),
                text: Text("Defeated"),
                textColor: .goverlandStatusPillDefeatedText,
                backgroundColor: .goverlandStatusPillDefeatedBackground)
        }
    }
}

fileprivate struct ListItemBubbleView: View {
    var image: Image?
    var text: Text
    var textColor: Color
    var backgroundColor: Color
    
    var body: some View {
        HStack(spacing: 3) {
            image
                .font(.system(size: 9))
                .foregroundColor(textColor)
            text
                .font(.system(size: 12))
                .foregroundColor(textColor)
                .fontWeight(.none)
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
        InboxListItemHeaderView(event: InboxEvent(
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
