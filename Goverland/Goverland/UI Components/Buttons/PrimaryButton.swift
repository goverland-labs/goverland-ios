//
//  PrimaryButton.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 30.06.23.
//

import SwiftUI

struct PrimaryButton: View {
    let text: String
    let maxWidth: CGFloat
    let maxHeight: CGFloat
    let isEnabled: Bool
    let action: () -> Void

    init(_ text: String,
         maxWidth: CGFloat = 400,
         maxHeight: CGFloat = 54,
         isEnabled: Bool = true,
         action: @escaping () -> Void) {
        self.text = text
        self.action = action
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
        self.isEnabled = isEnabled
    }

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Spacer()
                Text(text)
                Spacer()
            }
            .frame(maxWidth: maxWidth, maxHeight: maxHeight, alignment: .center)
            .background(Color.primary)
            .clipShape(Capsule())
            .tint(.onPrimary)
            .font(.headlineSemibold)
            .opacity(isEnabled ? 1.0 : 0.3)
        }
        .disabled(!isEnabled)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton("Primary Button", action: {})
    }
}
