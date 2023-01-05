//
//  ActivityListItemHeaderView.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI
import Kingfisher
import SwiftDate

struct ActivityListItemHeaderView: View {
    
    var event: ActivityEvent
    
    var body: some View {
        
        HStack {
            ActivityListItemHeaderImageView(event: event)
                .frame(width: 15, height: 15)
            ActivityListItemHeaderUserView(event: event)
            ActivityListItemHeaderTimeView(event: event)
            Spacer()
            ActivityListItemStatusBubbleView(event: event)
        }
    }
}

fileprivate struct ActivityListItemHeaderImageView: View {
    
    var event: ActivityEvent
    
    var body: some View {
        
        let url = URL(string: event.user.image)
        
        KFImage(url)
            .placeholder {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.purple)
            }
            .resizable()
            .setProcessor(ResizingImageProcessor(referenceSize: CGSize(width: 15, height: 15), mode: .aspectFit))
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

fileprivate struct ActivityListItemHeaderTimeView: View {
    
    var event: ActivityEvent
    
    var body: some View {
        
        Text(event.date.toRelative(since: DateInRegion()))
            .foregroundColor(.gray)
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
                image: Image(systemName: ""),
                text: Text("QUEUED"),
                backgroundColor: Color.yellow)
            
        case .succeeded:
            ListItemBubbleView(
                image: Image(systemName: ""),
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
            user: User(
                address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                image: "https://cdn-icons-png.flaticon.com/512/17/17004.png?w=1060&t=st=1672407609~exp=1672408209~hmac=7cb92bf848bb316a8955c5f510ce50f48c6a9484fb3641fa70060c212c2a8e39",
                name: "safe1.sche.eth"),
            date: Date(),
            type: .discussion,
            status: .discussion,
            content: ActivityViewContent(title: "", subtitle: "", warningSubtitle: ""),
            daoImage: "",
            meta: ["", "", ""]))
    }
}
