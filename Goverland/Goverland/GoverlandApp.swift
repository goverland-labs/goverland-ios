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
        #else
        print("PROD mode")
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
