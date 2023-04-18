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
            HStack(spacing: 6) {
                UserPictureView(userImage: event.user.image, imageSize: 16)
                InboxListItemHeaderUserView(event: event)
                InboxListItemDateView(event: event)
            }

            Spacer()
            
            HStack(spacing: 6) {
                InboxListItemReadIndicatiorView(event: event)
                InboxListItemStatusBubbleView(event: event)
            }
        }
    }
}

fileprivate struct InboxListItemHeaderUserView: View {
    var event: InboxEvent
    
    var body: some View {
        ZStack {
            if let name = event.user.ensName {
                Text(name)
                    .truncationMode(.tail)
            } else {
                Text(event.user.address)
                    .truncationMode(.middle)
            }
        }
        .font(.system(size: 13))
        .minimumScaleFactor(0.9)
        .lineLimit(1)
        .fontWeight(.medium)
        .foregroundColor(.textWhite)
        // TODO: implement truncate logic to keep 4 first and 4 last chars
        // frame restrictions won't work for bigger screens
        .frame(width: 70)
        
    }
}

fileprivate struct InboxListItemDateView: View {
    var event: InboxEvent
    
    var body: some View {
        Text(event.date.toRelative(since: DateInRegion()))
            .font(.system(size: 13))
            .minimumScaleFactor(0.9)
            .lineLimit(1)
            .fontWeight(.medium)
            .foregroundColor(.gray)
    }
}

fileprivate struct InboxListItemReadIndicatiorView: View {
    var event: InboxEvent
    
    var body: some View {
        Circle()
            .fill(.primary)
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
                text: Text("Active vote"),
                textColor: .onPrimary,
                backgroundColor: .primary)
        
        case .executed:
            ListItemBubbleView(
                image: Image(systemName: "checkmark"),
                text: Text("Executed"),
                textColor: .textWhite,
                backgroundColor: .success)
        
        case .failed:
            ListItemBubbleView(
                image: Image(systemName: "bolt.slash.fill"),
                text: Text("Failed"),
                textColor: .textWhite,
                backgroundColor: .fail)
        
        case .queued:
            ListItemBubbleView(
                image: Image(systemName: "clock"),
                text: Text("Queued"),
                textColor: .textWhite,
                backgroundColor: .warning)
            
        case .succeeded:
            ListItemBubbleView(
                image: Image(systemName: "checkmark"),
                text: Text("Succeeded"),
                textColor: .textWhite,
                backgroundColor: .success)
        
        case .defeated:
            ListItemBubbleView(
                image: Image(systemName: "xmark"),
                text: Text("Defeated"),
                textColor: .textWhite,
                backgroundColor: .danger)
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
                .font(.system(size: 9))
                .foregroundColor(textColor)
                .fontWeight(.semibold)
                .minimumScaleFactor(0.9)
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
