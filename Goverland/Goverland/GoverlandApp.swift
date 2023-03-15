//
//  GoverlandApp.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 15.12.22.
//

import SwiftUI

@main
struct GoverlandApp: App {
    @StateObject var colorSchemeManager = ColorSchemeManager()
    
    init() {
        #if DEV
        print("DEV mode")
        #elseif PROD
        print("PROD mode")
        #elseif DEBUG
        print("DEBUG mode")
        #else
        print("RELEASE mode")
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(colorSchemeManager)
                .onAppear() {
                    colorSchemeManager.applyColorScheme()
                }
        }
    }
}
