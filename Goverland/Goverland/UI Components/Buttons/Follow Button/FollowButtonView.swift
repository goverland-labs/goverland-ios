//
//  FollowButtonView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-12.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct FollowButtonView: View {
    @StateObject private var dataSource: FollowButtonDataSource
    @Setting(\.authToken) private var authToken
    let buttonWidth: CGFloat
    let buttonHeight: CGFloat
    var isFollowing: Bool { dataSource.subscriptionID != nil }

    init(daoID: UUID,
         subscriptionID: UUID?,
         onFollowToggle: ((_ didFollow: Bool) -> Void)?,
         buttonWidth: CGFloat = 100,
         buttonHeight: CGFloat = 32)
    {
        self.buttonWidth = buttonWidth
        self.buttonHeight = buttonHeight
        let dataSource = FollowButtonDataSource(daoID: daoID,
                                                subscriptionID: subscriptionID,
                                                onFollowToggle: onFollowToggle)
        _dataSource = StateObject(wrappedValue: dataSource)
    }

    var body: some View {
        if dataSource.isUpdating {
            ShimmerFollowButtonView()
        } else {
            Button(action: {
                if authToken.isEmpty {
                    NotificationCenter.default.post(name: .unauthorizedActionAttempt, object: nil)
                } else {
                    dataSource.toggle()
                }
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
    let buttonWidth: CGFloat
    let buttonHeight: CGFloat

    init(buttonWidth: CGFloat = 100, buttonHeight: CGFloat = 32) {
        self.buttonWidth = buttonWidth
        self.buttonHeight = buttonHeight
    }

    var body: some View {
        VStack {
            ShimmerView()
                .frame(width: buttonWidth, height: buttonHeight)
                .cornerRadius(buttonHeight / 2)
        }
    }
}
