//
//  DiscussionListView.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct DiscussionListItemView: View {
    
    var event: Event
    
    var body: some View {
        
        VStack {
            ListItemHeader(event: event)
            ListItemBody(event: event)
            ListItemFooter(event: event)
        }
    }
}

struct DiscussionListView_Previews: PreviewProvider {
    static var previews: some View {
        DiscussionListItemView(event: Event(type: .discussion))
    }
}
