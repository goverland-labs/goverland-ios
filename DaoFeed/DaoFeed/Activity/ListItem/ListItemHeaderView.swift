//
//  ListItemHeaderView.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct ListItemHeaderView: View {
    
    var event: Event
    
    var body: some View {
        
        HStack {
            ListItemHeaderImageView(event: event)
                .frame(width: 15, height: 15)
                //.fixedSize(horizontal: true, vertical: true)
            ListItemHeaderUserView()
            ListItemHeaderTimeView()
            Spacer()
            ListItemStatusBubbleView()
        }
    }
}

// TODO: Move to models

struct User {
    
    var address: String
    var endName: String
    var image: String
    
    init(address: String, image: String, name: String) {
        self.address = address
        self.endName = name
        self.image = image
    }
}


struct ListItemHeader_Previews: PreviewProvider {
    static var previews: some View {
        ListItemHeaderView(event: Event(type: .discussion, meta: []))
    }
}
