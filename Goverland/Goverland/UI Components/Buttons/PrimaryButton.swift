//
//  PrimaryButton.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 30.06.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct PrimaryButton: View {
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
            .background(isEnabled ? Color.primary : Color.disabled12)
            .clipShape(Capsule())
            .tint(.onPrimary)
            .font(font)
        }
        .disabled(!isEnabled)
    }
}
