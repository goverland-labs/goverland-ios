//
//  ListItemHeaderTimeView.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-30.
//

import SwiftUI
import SwiftDate

struct ListItemHeaderTimeView: View {
    var body: some View {
        
        // 3 min for testing, here will be time of listItem passing with Event object
        Text( (Date() - 3.minutes).toRelative(since: DateInRegion()) )
            .foregroundColor(.gray)
    }
}

struct ListItemHeaderTimeView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemHeaderTimeView()
    }
}
