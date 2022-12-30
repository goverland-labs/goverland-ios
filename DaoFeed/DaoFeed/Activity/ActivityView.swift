//
//  ActivityView.swift
//  DaoFeed
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct ActivityView: View {
    
    let event = Event(type: .discussion, meta: ["130", "238", "12"])
    
    var body: some View {
        
        List {
            ForEach(0..<10) { _ in
                
                ActivityListItemView(event: event)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init(top: 10, leading: 15, bottom: 20, trailing: 15))
            }
        }
        
    }
}

struct Event {
    
    private (set) var type: ListItemType = .undefined
    private (set) var meta: [String]
    
    init(type: ListItemType, meta: [String]) {
        self.type = type
        self.meta = meta
    }
}
                      
                      
// TODO: Move to models

enum ListItemType {
    case vote
    case discussion
    case undefined
}

enum ListItemStatus {
    case discussion
    case activeVote
    case executed
    case failed
    case queued
    case succeeded
    case defeated
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
