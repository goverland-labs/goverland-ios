//
//  DelegateButtonView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-07-24.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct DelegateButtonView: View {
    @StateObject private var dataSource: DelegateButtonDataSource
    @Setting(\.authToken) private var authToken
    let buttonWidth: CGFloat
    let buttonHeight: CGFloat
    var isFollowing: Bool { dataSource.delegationID != nil }

    init(delegationID: UUID?,
         onDelegateToggle: ((_ didFollow: Bool) -> Void)?,
         buttonWidth: CGFloat = 100,
         buttonHeight: CGFloat = 32)
    {
        self.buttonWidth = buttonWidth
        self.buttonHeight = buttonHeight
        let dataSource = DelegateButtonDataSource(delegationID: delegationID,
                                                onDelegateToggle: onDelegateToggle)
        _dataSource = StateObject(wrappedValue: dataSource)
    }

    var body: some View {
        if dataSource.isUpdating {
            ShimmerDelegateButtonView()
        } else {
            Button(action: {
                if authToken.isEmpty {
                    NotificationCenter.default.post(name: .unauthorizedActionAttempt, object: nil)
                } else {
                    if !isFollowing {
                        Haptic.medium()
                    }
                    dataSource.toggle()
                }
            }) {
                Text(isFollowing ? "Delegated" : "Delegate")
            }
            .frame(width: buttonWidth, height: buttonHeight, alignment: .center)
            .foregroundStyle(isFollowing ? Color.onSecondaryContainer : .onPrimary)
            .font(.footnoteSemibold)
            .background(isFollowing ? Color.secondaryContainer : Color.primary)
            .cornerRadius(buttonHeight / 2)
        }
    }
}

struct ShimmerDelegateButtonView: View {
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
