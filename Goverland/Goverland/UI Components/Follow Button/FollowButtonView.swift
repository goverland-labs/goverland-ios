//
//  FollowButtonView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-12.
//

import SwiftUI

struct FollowButtonView: View {
    @StateObject private var dataSource: FollowButtonDataSource
    let buttonWidth: CGFloat
    let buttonHeight: CGFloat
    var isFollowing: Bool { dataSource.subscriptionID != nil }

    init(daoID: UUID, subscriptionID: UUID?, buttonWidth: CGFloat = 110, buttonHeight: CGFloat = 35) {
        self.buttonWidth = buttonWidth
        self.buttonHeight = buttonHeight
        let dataSource = FollowButtonDataSource(daoID: daoID, subscriptionID: subscriptionID)
        _dataSource = StateObject(wrappedValue: dataSource)
    }

    var body: some View {
        if dataSource.isUpdating {
            ShimmerFollowButtonView()
        } else {
            Button(action: {
                dataSource.toggle()
            }) {
                Text(isFollowing ? "Following" : "Follow")
            }
            .frame(width: buttonWidth, height: buttonHeight, alignment: .center)
            .foregroundColor(isFollowing ? .onSecondaryContainer : .onPrimary)
            .font(.footnoteSemibold)
            .background(isFollowing ? Color.secondaryContainer : Color.primary)
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
        FollowButtonView(daoID: UUID(), subscriptionID: UUID())
    }
}
