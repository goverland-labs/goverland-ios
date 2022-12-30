//
//  ListItemFooterView.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct ListItemFooterView: View {
    
    var event: Event
    
    var body: some View {
        
        HStack(spacing: 20) {
            
            switch event.type {
            case .vote:
                VoteFooter(event: event)
            case .discussion:
                DiscussionFooter(event: event)
            case .undefined:
                Text("List type is undefined")
            }
            
            Spacer()
            
            ListFooterMenu()
        }
    }
}

struct DiscussionFooter: View {
    
    var event: Event
    
    var body: some View {
        HStack(spacing: 4) {
            
            Image(systemName: "text.bubble.fill")
                .resizable()
                .frame(width: 18, height: 16)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.gray)
            
            Text(event.meta[0])
        }
        
        HStack(spacing: 4) {
            
            Image(systemName: "eye.fill")
                .resizable()
                .frame(width: 20, height: 15)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.gray)
            
            Text(event.meta[1])
        }
        
        HStack(spacing: 4) {
            
            Image(systemName: "person.2.fill")
                .resizable()
                .frame(width: 20, height: 15)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.gray)
            
            Text(event.meta[2])
        }
    }
}

struct VoteFooter: View {
    
    var event: Event
    
    var body: some View {
        HStack(spacing: 4) {
            
            Image(systemName: "square.stack.3d.down.forward")
                .resizable()
                .frame(width: 15, height: 15)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.gray)
            
            Text(event.meta[0])
        }
        
        HStack(spacing: 4) {
            
            Image(systemName: "chart.bar.doc.horizontal.fill")
                .resizable()
                .frame(width: 15, height: 15)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.gray)
                .rotationEffect(.degrees(-90))
            
            Text(event.meta[1])
        }
    }
}

struct ListItemFooter_Previews: PreviewProvider {
    static var previews: some View {
        ListItemFooterView(event: Event(type: .discussion, meta: []))
    }
}
