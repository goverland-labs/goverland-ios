//
//  InboxListItemFooterView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct InboxListItemFooterView: View {
    var event: InboxEvent
    
    var body: some View {
        HStack(spacing: 20) {
            if let meta = event.meta as? InboxEventsDiscussionMeta {
                DiscussionFooterView(meta: meta)
            } else if let meta = event.meta as? InboxEventsVoteMeta {
                VoteFooterView(meta: meta)
            } 
        
            Spacer()
            
            InboxListFooterMenu()
        }
    }
}

fileprivate struct DiscussionFooterView: View {
    var meta: InboxEventsDiscussionMeta
    
    var body: some View {
        HStack(spacing: 10) {
            HStack(spacing: 5) {
                Image(systemName: "text.bubble.fill")
                    .foregroundColor(.gray)
                    .font(.system(size: 10))
                
                Text(String(meta.comments))
                    .fontWeight(.medium)
                    .font(.system(size: 13))
            }
            
            HStack(spacing: 5) {
                Image(systemName: "eye.fill")
                    .foregroundColor(.gray)
                    .font(.system(size: 10))
                
                Text(String(meta.views))
                    .fontWeight(.medium)
                    .font(.system(size: 13))
            }
            
            HStack(spacing: 5) {
                Image(systemName: "person.2.fill")
                    .foregroundColor(.gray)
                    .font(.system(size: 10))
                
                Text(String(meta.views))
                    .fontWeight(.medium)
                    .font(.system(size: 13))
            }
        }
    }
}

fileprivate struct VoteFooterView: View {
    var meta: InboxEventsVoteMeta
    
    var body: some View {
        HStack(spacing: 10) {
            HStack(spacing: 5) {
                Image(systemName: "person.fill")
                    .foregroundColor(.gray)
                    .font(.system(size: 10))
                
                Text(String(meta.voters))
                    .fontWeight(.medium)
                    .font(.system(size: 13))
            }
            
            HStack(spacing: 5) {
                Image(systemName: "flag.checkered")
                    .foregroundColor(.white)
                    .font(.system(size: 10))
                
                Text(meta.quorum)
                    .fontWeight(.medium)
                    .font(.system(size: 13))
            }
            
            if meta.voted {
                HStack(spacing: 1) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 9))
                        .foregroundColor(Color.goverlandStatusPillVotedText)
                    
                    Text("voted")
                        .font(.system(size: 10))
                        .foregroundColor(.goverlandStatusPillVotedText)
                        .fontWeight(.semibold)
                        .minimumScaleFactor(0.9)
                        .lineLimit(1)
                }
                .padding(5)
                .background(Capsule().fill(Color.goverlandStatusPillVotedBackground))
            }
        }
    }
}

fileprivate struct InboxListFooterMenu: View {
    var body: some View {
        HStack(spacing: 15) {
            // TODO: add logic to indicate following or not
            Image(systemName: "bell.slash.fill")
                .foregroundColor(.gray)
                .frame(width: 11, height: 10)
            
            Menu {
                Button("Share", action: performShare)
                Button("Cancel", action: performCancel)
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
                    .fontWeight(.bold)
                    .frame(width: 20, height: 20)
            }
        }
    }
    
    private func performShare() {}
    
    private func performCancel() {}
}

struct ListItemFooter_Previews: PreviewProvider {
    static var previews: some View {
        InboxListItemFooterView(event: InboxEvent(
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
