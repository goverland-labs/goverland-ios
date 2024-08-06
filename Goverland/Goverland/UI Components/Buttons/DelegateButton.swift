//
//  DelegateButton.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-08-06.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DelegateButton: View {
    let maxWidth: CGFloat
    let height: CGFloat
    let isDelegated: Bool
    let action: () -> Void

    init(maxWidth: CGFloat = 100,
         height: CGFloat = 32,
         isDelegated: Bool,
         action: @escaping () -> Void) {
        self.maxWidth = maxWidth
        self.height = height
        self.isDelegated = isDelegated
        self.action = action
    }

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Spacer()
                Text(isDelegated ? "Delegated" : "Delegate")
                    .font(.footnoteSemibold)
                    .foregroundColor(Color.textWhite)
                Spacer()
            }
            .frame(minWidth: maxWidth * 1/3,
                   maxWidth: maxWidth,
                   minHeight: height,
                   maxHeight: height,
                   alignment: .center)
            .background(isDelegated ? Color.tertiaryContainer : Color.clear)
            .background(
                Capsule().stroke(isDelegated ? Color.clear : Color.textWhite, lineWidth: 1)
            )
            .clipShape(Capsule())
            .tint(.onPrimary)
        }
    }
}
