//
//  ListStatusBubbleView.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct ListStatusBubbleView: View {
    
    @State var listStatus: ListStatus  = .executed
    
    var body: some View {
        
        switch self.listStatus {
        case .discussion:
            ListDiscussionBubbleView()
        case .activeVote:
            ListActiveVoteBubbleView()
        case .executed:
            ListExecutedBubbleView()
        case .failed:
            Text("failed goes here")
        case .queue:
            Text("queue goes here")
        }
    }
}


struct ListDiscussionBubbleView: View {
    var body: some View {
        HStack(spacing: 0) {
            
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 9))
                .foregroundColor(.white)
            
            Text("DISCUSSION")
                .font(.system(size: 12))
                .foregroundColor(.white)
                .fontWeight(.bold)
                .minimumScaleFactor(0.1)
                .lineLimit(1)
        }
            .frame(width: 110, height: 20)
            .background(.gray)
            .cornerRadius(50)
    }
}

struct ListActiveVoteBubbleView: View {
    var body: some View {
        HStack(spacing: 0) {
            
            Image(systemName: "plus")
                .font(.system(size: 9))
                .foregroundColor(.white)
                .fontWeight(.bold)
            
            Text("ACTIVE VOTE")
                .font(.system(size: 12))
                .foregroundColor(.white)
                .fontWeight(.bold)
                //.minimumScaleFactor(0.1)
                .lineLimit(1)
        }
            .frame(width: 110, height: 20)
            .background(.blue)
            .cornerRadius(50)
    }
}

struct ListExecutedBubbleView: View {
    var body: some View {
        HStack(spacing: 0) {
            
            Image(systemName: "checkmark")
                .font(.system(size: 9))
                .foregroundColor(.white)
                .fontWeight(.bold)
            
            Text("EXECUTED")
                .font(.system(size: 12))
                .foregroundColor(.white)
                .fontWeight(.bold)
                .minimumScaleFactor(0.1)
                .lineLimit(1)
        }
            .frame(width: 90, height: 20)
            .background(.green)
            .cornerRadius(50)
    }
}


struct ListStatusBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        ListStatusBubbleView()
    }
}
