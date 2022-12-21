//
//  ListStatusBubbleView.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct ListStatusBubbleView: View {
    
    @State var listStatus: ListStatus  = .discussion
    
    var body: some View {
        
        switch self.listStatus {
        case .discussion:
            ListDiscussionBubbleView()
        case .activeVote:
            ListActiveVoteBubbleView()
        case .executed:
            ListExecutedBubbleView()
        case .failed:
            ListFailedBubbleView()
        case .queue:
            ListQueuedBubbleView()
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

struct ListFailedBubbleView: View {
    var body: some View {
        HStack(spacing: 0) {
            
            Image(systemName: "xmark")
                .font(.system(size: 9))
                .foregroundColor(.white)
                .fontWeight(.bold)
            
            Text(" FAILED")
                .font(.system(size: 12))
                .foregroundColor(.white)
                .fontWeight(.bold)
                .minimumScaleFactor(0.1)
                .lineLimit(1)
        }
            .frame(width: 65, height: 20)
            .background(.red)
            .cornerRadius(50)
    }
}

struct ListQueuedBubbleView: View {
    var body: some View {
        HStack(spacing: 0) {
            
            Text("QUEUED")
                .font(.system(size: 12))
                .foregroundColor(.white)
                .fontWeight(.bold)
                .minimumScaleFactor(0.1)
                .lineLimit(1)
        }
            .frame(width: 70, height: 20)
            .background(.yellow)
            .cornerRadius(50)
    }
}


struct ListStatusBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        ListStatusBubbleView()
    }
}
