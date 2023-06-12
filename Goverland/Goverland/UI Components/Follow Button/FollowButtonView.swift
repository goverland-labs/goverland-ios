//
//  FollowButtonView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-12.
//

import SwiftUI

struct FollowButtonView: View {
    @State private var didTap: Bool = false
    let buttonWidth: CGFloat
    let buttonHeight: CGFloat
    
    var body: some View {
        Button(action: { didTap.toggle() }) {
            Text(didTap ? "Following" : "Follow")
        }
        .frame(width: buttonWidth, height: buttonHeight, alignment: .center)
        .foregroundColor(didTap ? .onSecondaryContainer : .onPrimary)
        .font(.footnoteSemibold)
        .background(didTap ? Color.secondaryContainer : Color.primary)
        .cornerRadius(buttonHeight / 2)
    }
}

struct FollowButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FollowButtonView(buttonWidth: 100,
                         buttonHeight: 30)
    }
}
