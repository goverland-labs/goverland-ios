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
    let maxWidth: CGFloat = 400
    let maxHeight: CGFloat = 54


    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Spacer()
                Text(text)
                Spacer()
            }
        }
        .frame(maxWidth: maxWidth, maxHeight: maxHeight, alignment: .center)
        .background(Color.primary)
        .clipShape(Capsule())
        .tint(.onPrimary)
        .font(.headlineSemibold)
    }
}


struct GhostActionButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: 60, alignment: .center)
            .background(Color.primary)
            .clipShape(Capsule())
            .tint(.onPrimary)
            .font(.headlineSemibold)
    }
}

struct GhostReadMoreButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 100, height: 30, alignment: .center)
            .background(Capsule(style: .circular)
                .stroke(Color.secondaryContainer,style: StrokeStyle(lineWidth: 2)))
            .tint(.onSecondaryContainer)
            .font(.footnoteSemibold)
    }
}

extension View {
    func ghostActionButtonStyle() -> some View {
        modifier(GhostActionButton())
    }

    func ghostReadMoreButtonStyle() -> some View {
        modifier(GhostReadMoreButton())
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(text: "Primary Button", action: {})
    }
}
