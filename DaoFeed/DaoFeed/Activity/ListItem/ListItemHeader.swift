//
//  ListItemHeader.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI


struct ListItemHeader: View {
    
    var event: Event
    
    var body: some View {
        HStack {
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 15, height: 15)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.purple)
            
            Text("nickname")
                .fontWeight(.semibold)
            
            Text("2 days ago")
                .foregroundColor(.gray)
            Spacer() // to push content to the left edge
            ListItemStatusBubbleView()
        }
    }
}

struct ListItemHeader_Previews: PreviewProvider {
    static var previews: some View {
        ListItemHeader(event: Event(type: .discussion))
    }
}
