//
//  SwiftUIExtentions.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 08.02.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

extension UIScreen {
    static var screenWidth: CGFloat { UIScreen.main.bounds.size.width }
    static var screenHeight: CGFloat { UIScreen.main.bounds.size.height }
    static var screenSize: CGSize { UIScreen.main.bounds.size }
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
    mutating func appendUnique(contentsOf newElements: [Element]) -> Int {
        var appended = 0
        for element in newElements {
            if !contains(element) {
                append(element)
                appended += 1
            }
        }
        return appended
    }
}
