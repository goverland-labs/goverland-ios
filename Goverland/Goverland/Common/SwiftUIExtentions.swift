//
//  SwiftUIExtentions.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 08.02.23.
//

import SwiftUI

extension UIScreen {
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

extension View {
    func ghostActionButtonStyle() -> some View {
        modifier(GhostActionButton())
    }
    
    func ghostReadMoreButtonStyle() -> some View {
        modifier(GhostReadMoreButton())
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

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
