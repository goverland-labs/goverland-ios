//
//  ListItemHeader.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI
import Kingfisher

struct ListItemHeader: View {
    var body: some View {
        HStack {
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 15, height: 15)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.purple)
            
            Text("nickname")
                .fontWeight(.semibold)
            
            Text("2 days ago")
                .foregroundColor(.gray)
            Spacer() // to push content to the left edge
            ListStatusBubbleView()
        }
    }
}

struct ListItemHeader_Previews: PreviewProvider {
    static var previews: some View {
        ListItemHeader()
    }
}
