//
//  ListStatusBubbleView.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct ListStatusBubbleView: View {
    var body: some View {
        HStack(spacing: 0) {
            
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 9))
                .foregroundColor(.white)
            
            Text("DISCUSSION")
                .font(.system(size: 12))
                .foregroundColor(.white)
                .fontWeight(.bold)
                .minimumScaleFactor(0.1)
                .lineLimit(1)
        }
            .frame(width: 110, height: 20)
            .background(.gray)
            .cornerRadius(50)
    }
}

struct ListStatusBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        ListStatusBubbleView()
    }
}
