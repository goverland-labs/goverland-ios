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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

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
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        AuthManager.shared.updateToken()
        return true
    }
}
