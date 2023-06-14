//
//  FollowButtonView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-12.
//

import SwiftUI

struct FollowButtonView: View {
    @StateObject private var dataSource = FollowButtonDataSource()
    @State var isSubscribed: Bool
    let daoID: UUID
    let buttonWidth: CGFloat = 110
    let buttonHeight: CGFloat = 35

    var body: some View {
        if dataSource.isUpdating {
            ShimmerFollowButtonView()
        } else {
            Button(action: {
                if isSubscribed {
                    dataSource.unfollowDao(id: daoID)
                } else {
                    dataSource.followDao(id: daoID)
                }
                isSubscribed.toggle()
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
}

struct ShimmerFollowButtonView: View {
    var body: some View {
        VStack {
            ShimmerView()
                .frame(width: 110, height: 35)
                .cornerRadius(17)
        }
    }
}

struct FollowButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FollowButtonView(isSubscribed: true, daoID: UUID())
    }
}
