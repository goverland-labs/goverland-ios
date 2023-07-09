//
//  GoverlandApp.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 15.12.22.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging

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
                    .overlay {
                        ErrorView()
                    }
                }
                .overlay {
                    ErrorView()
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        AuthManager.shared.updateToken()
        FirebaseApp.configure()
        NotificationsManager.setUpMessaging(delegate: self)
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        logInfo("PUSH: App is in foreground, willPresent notification with userInfo: \(userInfo)")
        completionHandler([.badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        logInfo("PUSH: didReceive notification with userInfo: \(userInfo)")
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // TODO: handle
    }
}
