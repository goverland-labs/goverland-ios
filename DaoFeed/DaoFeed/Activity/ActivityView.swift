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
            
        List(0..<10) { _ in
            
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
}

enum ListType {
    case vote
    case discussion
    case undefined
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(listType: .vote)
    }
}
