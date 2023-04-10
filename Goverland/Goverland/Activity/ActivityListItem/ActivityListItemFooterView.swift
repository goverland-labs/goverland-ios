//
//  ActivityListItemFooterView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct ActivityListItemFooterView: View {
    
    var event: ActivityEvent
    
    var body: some View {
        
        HStack(spacing: 20) {
            
            if let meta = event.meta as? ActivityEventsDiscussionMeta {
                DiscussionFooterView(meta: meta)
            } else if let meta = event.meta as? ActivityEventsVoteMeta {
                VoteFooterView(meta: meta)
            } 
        
            Spacer()
            
            ActivityListFooterMenu()
        }
    }
}

fileprivate struct DiscussionFooterView: View {
    
    var meta: ActivityEventsDiscussionMeta
    
    var body: some View {
        
        HStack(spacing: 8) {
            
            Image(systemName: "text.bubble.fill")
                .resizable()
                .frame(width: 18, height: 16)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.gray)
            
            Text(String(meta.comments))
        }
        
        HStack(spacing: 8) {
            
            Image(systemName: "eye.fill")
                .resizable()
                .frame(width: 20, height: 15)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.gray)
            
            Text(String(meta.views))
        }
        
        HStack(spacing: 8) {
            
            Image(systemName: "person.2.fill")
                .resizable()
                .frame(width: 20, height: 15)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.gray)
            
            Text(String(meta.views))
        }
    }
}

fileprivate struct VoteFooterView: View {
    
    var meta: ActivityEventsVoteMeta
    
    var body: some View {
        
        HStack(spacing: 8) {
            
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 15, height: 15)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.gray)
            
            Text(String(meta.voters))
        }
        
        HStack(spacing: 8) {
            
            Image(systemName: "flag.checkered")
                .resizable()
                .frame(width: 15, height: 15)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.white)
            
            Text(meta.quorum)
            
            
        }
        
        if meta.voted {
            HStack(spacing: 1) {
                
                Image(systemName: "checkmark")
                    .font(.system(size: 9))
                    .foregroundColor(.green)
                
                Text("voted")
                    .font(.system(size: 10))
                    .foregroundColor(.green)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
            }
            .padding(5)
            .background(Capsule().fill(Color(UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.2))))
        }
    }
}

fileprivate struct ActivityListFooterMenu: View {
    var body: some View {
        
        HStack {
            // TODO: add logic to indicate following or not
            Image(systemName: "bell.slash.fill")
                .foregroundColor(.gray)
            
            Menu {
                
                Button("Share", action: performShare)
                Button("Cancel", action: performCancel)
                
            } label: {
                
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
                .fontWeight(.bold)
                
            }
        }
    }
    
    private func performShare() {
        
    }
    
    private func performCancel() {
        
    }
}


struct ListItemFooter_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListItemFooterView(event: ActivityEvent(
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
