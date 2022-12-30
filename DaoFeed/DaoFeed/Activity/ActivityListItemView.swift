//
//  ActivityListItemView.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-28.
//

import SwiftUI

struct ActivityListItemView: View {
    
    var event: Event
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 5)
                .fill(.white)
                .padding(.horizontal, -15.0)
            
            
            switch event.type {
            case .vote:
                ActivityVoteListItemView(event: event)
            case .discussion:
                ActivityDiscussionListItemView(event: event)
            case .undefined:
                Text("List type is undefined")
            }
        }
    }
}

struct ActivityListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListItemView(event: Event(type: .discussion, meta: []))
    }
}
