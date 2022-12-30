//
//  VoteListView.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct ActivityVoteListItemView: View {
    
    var event: Event
    
    var body: some View {
        
        VStack(spacing: 20) {
            ActivityListItemHeaderView(event: event)
            ActivityListItemBodyView(event: event)
            ActivityListItemFooterView(event: event)
        }
    }
    
}

struct VoteListView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityVoteListItemView(event: Event(type: .discussion, meta: []))
    }
}
