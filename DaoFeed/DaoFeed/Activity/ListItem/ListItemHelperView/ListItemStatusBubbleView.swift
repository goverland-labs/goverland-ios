//
//  ListItemStatusBubbleView.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct ListItemStatusBubbleView: View {
    
    var listItemStatus: ListItemStatus  = .discussion
    
    var body: some View {
        
        switch self.listItemStatus {
        
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
                image: Image(systemName: "plus"),
                text: Text("EXECUTED"),
                backgroundColor: Color.green)
        
        case .failed:
            ListItemBubbleView(
                image: Image(systemName: "xmark"),
                text: Text(" FAILED"),
                backgroundColor: Color.red)
        
        case .queued:
            ListItemBubbleView(
                image: Image(systemName: "plus"),
                text: Text("QUEUED"),
                backgroundColor: Color.yellow)
        }
    }
}

struct ListItemBubbleView: View {
    
    var image: Image?
    var text: Text
    var backgroundColor: Color
    
    var body: some View {
        HStack(spacing: 0) {
            
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
        .padding(4)
        .background(Capsule().fill(backgroundColor))
    }
}

struct ListStatusBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemStatusBubbleView()
    }
}
