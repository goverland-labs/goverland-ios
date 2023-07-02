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

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

extension Array where Element: Equatable {
    mutating func appendUnique(contentsOf newElements: [Element]) {
        for element in newElements {
            if !contains(element) {
                append(element)
            }
        }
    }
}
