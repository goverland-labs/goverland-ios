//
//  SecondaryButton.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-06.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct SecondaryButton: View {
    let text: String
    let maxWidth: CGFloat
    let height: CGFloat
    let isEnabled: Bool
    let disabledText: String?
    let font: Font
    let action: () -> Void

    init(_ text: String,
         maxWidth: CGFloat = 400,
         height: CGFloat = 54,
         isEnabled: Bool = true,
         disabledText: String? = nil,
         font: Font = .headlineSemibold,
         action: @escaping () -> Void) {
        self.text = text
        self.action = action
        self.maxWidth = maxWidth
        self.height = height
        self.isEnabled = isEnabled
        self.disabledText = disabledText
        self.font = font
    }

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Spacer()
                Text(isEnabled ? text : (disabledText ?? text))
                Spacer()
            }
            .frame(minWidth: maxWidth * 1/3,
                   maxWidth: maxWidth,
                   minHeight: height,
                   maxHeight: height,
                   alignment: .center)
            .tint(.textWhite)
            .background(
                Capsule()
                    .stroke(Color.textWhite, lineWidth: 1)
            )
            .font(font)
            .opacity(isEnabled ? 1.0 : 0.3)
        }
        .disabled(!isEnabled)
    }
}
