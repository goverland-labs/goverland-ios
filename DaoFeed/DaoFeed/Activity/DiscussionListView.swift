//
//  DiscussionListView.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct DiscussionListView: View {
    var body: some View {
        
        VStack {
            ListItemHeader()
            ListItemBody()
            ListItemFooter()
        }
    }
}

struct DiscussionListView_Previews: PreviewProvider {
    static var previews: some View {
        DiscussionListView()
    }
}
