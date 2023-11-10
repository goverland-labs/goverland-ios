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
    let maxHeight: CGFloat
    let isEnabled: Bool
    let disabledText: String?
    let action: () -> Void

    init(_ text: String,
         maxWidth: CGFloat = 400,
         maxHeight: CGFloat = 54,
         isEnabled: Bool = true,
         disabledText: String? = nil,
         action: @escaping () -> Void) {
        self.text = text
        self.action = action
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
        self.isEnabled = isEnabled
        self.disabledText = disabledText
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
            .frame(maxWidth: maxWidth, maxHeight: maxHeight, alignment: .center)
            .tint(.textWhite)
            .background(
                Capsule()
                    .stroke(Color.textWhite, lineWidth: 1)
            )
            .font(.headlineSemibold)
            .opacity(isEnabled ? 1.0 : 0.3)
        }
        .disabled(!isEnabled)
    }
}

struct SecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        SecondaryButton("Secondary Button", action: {})
    }
}
