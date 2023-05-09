//
//  InboxDetailStatusRow.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-18.
//

import SwiftUI
import SwiftDate

struct InboxDetailStatusRowView: View {
    var body: some View {
        HStack {
            HStack(spacing: 3) {
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
            .padding([.leading, .trailing], 5)
            .padding([.top, .bottom], 4)
            .background(Capsule().fill(Color.gray))
            
            Spacer()
            
            HStack(spacing: 5) {
                Text("Discussion started")
                Text(Date().toFormat("MMM d, yyyy"))
            }
        }
        .padding(10)
        .background(Color.gray)
        .cornerRadius(10)
    }
}

struct InboxDetailStatusRow_Previews: PreviewProvider {
    static var previews: some View {
        InboxDetailStatusRowView()
    }
}
