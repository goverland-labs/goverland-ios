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
}

struct GhostActionButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: 60, alignment: .center)
            .background(Color.blue)
            .clipShape(Capsule())
            .tint(.white)
            .fontWeight(.bold)
            .padding(.horizontal, 30)
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

extension Color {
    static let darkGray = Color(red: 0.261, green: 0.261, blue: 0.261)
}
