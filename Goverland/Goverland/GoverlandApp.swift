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
    @StateObject var tokenData = AuthDataSource()

    init() {
        #if DEV
        Tracker.append(handler: ConsoleTracker())
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
                    if tokenData.isEmpty {
                        tokenData.getToken()
                    }
                }
        }
    }
}
