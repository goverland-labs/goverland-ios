//
//  ListItemFooter.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct ListItemFooter: View {
    
    var footerType: ListType
    
    var body: some View {
        
        HStack(spacing: 20) {
            
            switch self.footerType {
            case .vote:
                VoteFooter()
            case .discussion:
                DiscussionFooter()
            default:
                Text("List type is undefined")
            }
            
            Spacer()
            
            ListFooterMenu()
        }
    }
}

struct DiscussionFooter: View {
    
    var body: some View {
        HStack(spacing: 4) {
            
            Image(systemName: "text.bubble.fill")
                .resizable()
                .frame(width: 18, height: 16)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.gray)
            
            Text("239")
        }
        
        HStack(spacing: 4) {
            
            Image(systemName: "eye.fill")
                .resizable()
                .frame(width: 20, height: 15)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.gray)
            
            Text("150")
        }
        
        HStack(spacing: 4) {
            
            Image(systemName: "person.2.fill")
                .resizable()
                .frame(width: 20, height: 15)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.gray)
            
            Text("12")
        }
    }
}

struct VoteFooter: View {
    
    var body: some View {
        HStack(spacing: 4) {
            
            Image(systemName: "square.stack.3d.down.forward")
                .resizable()
                .frame(width: 15, height: 15)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.gray)
            
            Text("239")
        }
        
        HStack(spacing: 4) {
            
            Image(systemName: "chart.bar.doc.horizontal.fill")
                .resizable()
                .frame(width: 15, height: 15)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.gray)
                .rotationEffect(.degrees(-90))
            
            Text("150%")
        }
    }
}

struct ListItemFooter_Previews: PreviewProvider {
    static var previews: some View {
        ListItemFooter(footerType: .discussion)
    }
}
