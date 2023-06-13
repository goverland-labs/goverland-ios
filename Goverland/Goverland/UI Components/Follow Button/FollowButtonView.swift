//
//  FollowButtonView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-12.
//

import SwiftUI

struct FollowButtonView: View {
    @State var isSubscribed: Bool
    let daoID: UUID
    let buttonWidth: CGFloat = 110
    let buttonHeight: CGFloat = 35

    var body: some View {
        Button(action: { isSubscribed.toggle()
            // call datasource (for POST and DELETE)
            // shimmer while change status
        }) {
            
            Text(isSubscribed ? "Following" : "Follow")
        }
        .frame(width: buttonWidth, height: buttonHeight, alignment: .center)
        .foregroundColor(isSubscribed ? .onSecondaryContainer : .onPrimary)
        .font(.footnoteSemibold)
        .background(isSubscribed ? Color.secondaryContainer : Color.primary)
        .cornerRadius(buttonHeight / 2)
    }
}

struct FollowButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FollowButtonView(isSubscribed: true, daoID: UUID())
    }
}
