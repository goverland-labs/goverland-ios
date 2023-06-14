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

    init(isFollowing: Bool, daoID: UUID, buttonWidth: CGFloat = 110, buttonHeight: CGFloat = 35) {
        self.buttonWidth = buttonWidth
        self.buttonHeight = buttonHeight
        let dataSource = FollowButtonDataSource(isFollowing: isFollowing, daoID: daoID)
        _dataSource = StateObject(wrappedValue: dataSource)

    }

    var body: some View {
        if dataSource.isUpdating {
            ShimmerFollowButtonView()
        } else {
            Button(action: {
                dataSource.toggle()
            }) {
                Text(dataSource.isFollowing ? "Following" : "Follow")
            }
            .frame(width: buttonWidth, height: buttonHeight, alignment: .center)
            .foregroundColor(dataSource.isFollowing ? .onSecondaryContainer : .onPrimary)
            .font(.footnoteSemibold)
            .background(dataSource.isFollowing ? Color.secondaryContainer : Color.primary)
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
        FollowButtonView(isFollowing: true, daoID: UUID())
    }
}
