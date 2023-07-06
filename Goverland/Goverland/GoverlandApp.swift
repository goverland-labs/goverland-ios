//
//  GoverlandApp.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 15.12.22.
//

import SwiftUI

@main
struct GoverlandApp: App {
    @StateObject private var colorSchemeManager = ColorSchemeManager()
    @StateObject private var activeSheetManger = ActiveSheetManager()
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
                .environmentObject(activeSheetManger)
                .onAppear() {
                    colorSchemeManager.applyColorScheme()
                }
                .sheet(item: $activeSheetManger.activeSheet) { item in
                    NavigationStack {
                        switch item {
                        case .daoInfo(let dao):
                            DaoInfoView(dao: dao)
                        case .followDaos:
                            AddSubscriptionView()
                        }
                    }
                    .accentColor(.primary)
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
