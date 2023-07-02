//
//  PrimaryButton.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 30.06.23.
//

import SwiftUI

struct PrimaryButton: View {
    let text: String
    let action: () -> Void
    let maxWidth: CGFloat
    let maxHeight: CGFloat

    init(_ text: String,
         action: @escaping () -> Void,
         maxWidth: CGFloat = 400,
         maxHeight: CGFloat = 54) {
        self.text = text
        self.action = action
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
    }

    var body: some View {
        Button(action: {
            action()
        }) {
            PrimaryButtonView(text, maxWidth: maxWidth, maxHeight: maxHeight)
        }
    }
}

struct PrimaryButtonView: View {
    let text: String
    let maxWidth: CGFloat
    let maxHeight: CGFloat

    init(_ text: String,
         maxWidth: CGFloat = 400,
         maxHeight: CGFloat = 54) {
        self.text = text
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
    }

    var body: some View {
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
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton("Primary Button", action: {})
    }
}
