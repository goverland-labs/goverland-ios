//
//  GoverlandApp.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 15.12.22.
//

import SwiftUI
import Firebase

@main
struct GoverlandApp: App {
    @StateObject private var colorSchemeManager = ColorSchemeManager()
    @StateObject private var activeSheetManger = ActiveSheetManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

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
                        case .proposalVoters(let proposal):
                            SnapshotAllVotesView(proposal: proposal)
                        }
                    }
                    .accentColor(.primary)
                    .overlay {
                        ToastView()
                    }
                }
                .overlay {
                    ToastView()
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Setup App Tracking
        Tracker.append(handler: ConsoleTrackingHandler())
        Tracker.append(handler: FirebaseTrackingHandler())
        // Very important line of code. Do not remove it.
        Tracker.setTrackingEnabled(SettingKeys.shared.trackingAccepted)

        // Obtain session token. If a user is new, this will be a guest token,
        // otherwise this will be signed in user token.
        AuthManager.shared.updateToken()

        // Setup Firebase
        FirebaseConfig.setUp()

        // Run WalletConnect manager initializer that will configure WalletConnect required parameters.
        _ = WC_Manager.shared

        // Setup Push Notifications Manager
        NotificationsManager.shared.setUpMessaging(delegate: self)

        return true
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        logInfo("PUSH: didReceiveRemoteNotification with userInfo: \(userInfo)")
        completionHandler(.noData)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // It should not be called because Firebase should swizzle this method
        logInfo("[WARNING] Called didRegisterForRemoteNotificationsWithDeviceToken")
        Messaging.messaging().apnsToken = deviceToken
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
        logInfo("FCM Token: \(fcmToken ?? "unknown")")
        // Try to notify backend. It will make a check that notifications are enabled by user.
        NotificationsManager.shared.enableNotifications()
    }
}
