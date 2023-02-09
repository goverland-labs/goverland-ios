//
//  SwiftUIExtentions.swift
//  DaoFeed
//
//  Created by Andrey Scherbovich on 08.02.23.
//

import SwiftUI

extension UIScreen {
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

struct GhostActionButtons: ViewModifier {
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
