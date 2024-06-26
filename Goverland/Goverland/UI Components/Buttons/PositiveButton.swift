//
//  PositiveButton.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 26.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct PositiveButton: View {
    let text: String
    let width: CGFloat
    let height: CGFloat
    let action: () -> Void

    init(_ text: String,
         width: CGFloat = 100,
         height: CGFloat = 32,
         action: @escaping () -> Void) {
        self.text = text
        self.width = width
        self.height = height
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
        }
        .frame(width: width, height: height, alignment: .center)
        .foregroundStyle(Color.onSecondaryContainer)
        .font(.footnoteSemibold)
        .background(Color.secondaryContainer)
        .cornerRadius(height / 2)
    }
}
