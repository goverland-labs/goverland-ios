//
//  DangerButton.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 15.12.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DangerButton: View {
    let text: String
    let maxWidth: CGFloat
    let height: CGFloat
    let isEnabled: Bool
    let disabledText: String?
    let action: () -> Void

    init(_ text: String,
         maxWidth: CGFloat = 400,
         height: CGFloat = 54,
         isEnabled: Bool = true,
         disabledText: String? = nil,
         action: @escaping () -> Void) {
        self.text = text
        self.action = action
        self.maxWidth = maxWidth
        self.height = height
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
            .frame(minWidth: maxWidth * 1/3,
                   maxWidth: maxWidth,
                   minHeight: height,
                   maxHeight: height,
                   alignment: .center)
            .background(Color.red)
            .clipShape(Capsule())
            .tint(.textWhite)
            .font(.headlineSemibold)
        }
        .disabled(!isEnabled)
    }
}
