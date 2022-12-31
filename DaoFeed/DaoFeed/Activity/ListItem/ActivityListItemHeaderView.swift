//
//  ActivityListItemHeaderView.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct ActivityListItemHeaderView: View {
    
    var event: Event
    
    var body: some View {
        
        HStack {
            ActivityListItemHeaderImageView(event: event)
                .frame(width: 15, height: 15)
                //.fixedSize(horizontal: true, vertical: true)
            ActivityListItemHeaderUserView()
            ActivityListItemHeaderTimeView()
            Spacer()
            ActivityListItemStatusBubbleView()
        }
    }
}

// TODO: Move to models

struct User {
    
    var address: String
    var endsName: String
    var image: String
    
    init(address: String, image: String, name: String) {
        self.address = address
        self.endsName = name
        self.image = image
    }
}


struct ListItemHeader_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListItemHeaderView(event: Event(type: .discussion, meta: []))
    }
}
