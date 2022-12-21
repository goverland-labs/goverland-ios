//
//  ActivityView.swift
//  DaoFeed
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct ActivityView: View {
        
    @State var listType: ListType  = .discussion
        
    var body: some View {
        
        List {
            ForEach(0..<10) { _ in
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.white)
                        .padding(.horizontal, -15.0)
                    
                    
                    switch self.listType {
                    case .vote:
                        VoteListView()
                    case .discussion:
                        DiscussionListView()
                    default:
                        Text("List type is undefined")
                    }
                }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 10, leading: 15, bottom: 20, trailing: 15))
        }
        
    }
}

enum ListType {
    case vote
    case discussion
    case undefined
}

enum ListStatus {
    case discussion
    case activeVote
    case executed
    case failed
    case queue
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(listType: .discussion)
    }
}
