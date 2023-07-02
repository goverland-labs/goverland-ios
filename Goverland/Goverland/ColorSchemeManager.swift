//
//  ColorSchemeManager.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-28.
//

import SwiftUI

class ColorSchemeManager: ObservableObject {
    @AppStorage("colorScheme") var colorScheme: ColorSchemeType = .dark
    
    var keyWindow : UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = windowSceneDelegate.window else {
                  return nil
              }
        return window
    }
    
    func applyColorScheme() {
        keyWindow?.overrideUserInterfaceStyle = UIUserInterfaceStyle(rawValue: colorScheme.rawValue)!
    }
}

enum ColorSchemeType: Int {
    case unspecified, light, dark
}
