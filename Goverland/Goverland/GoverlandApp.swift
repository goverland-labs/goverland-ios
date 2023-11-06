//
//  GoverlandApp.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 15.12.22.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import Firebase

@main
struct GoverlandApp: App {
    @StateObject private var colorSchemeManager = ColorSchemeManager()
    @StateObject private var activeSheetManger = ActiveSheetManager()
    @Environment(\.scenePhase) private var scenePhase
    @Setting(\.authToken) var authToken
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(colorSchemeManager)
                .environmentObject(activeSheetManger)
                .onAppear() {
                    colorSchemeManager.applyColorScheme()
                }
                .onChange(of: scenePhase) { newPhase in
                    switch newPhase {
                    case .inactive:
                        logInfo("[App] Did become inactive")
                    case .active:
                        logInfo("[App] Did enter foreground")

                        // Also called when closing system dialogue to enable push notifications.
                        // Don't refresh inbox feed if some popover screen is presented. This adjustment is needed
                        // to not request initial inbox feed forming after a user follows the first DAO
                        // and then confirms notifications with system dialogue.
                        // Without this adjustment the initial feed will always be formed for one DAO only.
                        if !authToken.isEmpty && activeSheetManger.activeSheet == nil {
                            InboxDataSource.shared.refresh()
                        }
                    case .background:
                        logInfo("[App] Did enter background")
                    @unknown default: break
                    }
                }
                .sheet(item: $activeSheetManger.activeSheet) { item in
                    switch item {
                    case .daoInfo(let dao):
                        NavigationStack {
                            DaoInfoView(dao: dao)
                        }
                        .accentColor(.textWhite)
                        .overlay {
                            ToastView()
                        }

                    case .followDaos:
                        NavigationStack {
                            AddSubscriptionView()
                        }
                        .accentColor(.textWhite)
                        .overlay {
                            ToastView()
                        }

                    case .archive:
                        // If ArchiveView is places in NavigationStack, it brakes SwiftUI on iPhone
                        ArchiveView()
                    
                    case .subscribeToNotifications:
                        EnablePushNotificationsView()
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
        logInfo("[PUSH] didReceiveRemoteNotification with userInfo: \(userInfo)")
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
        logInfo("[PUSH] App is in foreground, willPresent notification with userInfo: \(userInfo)")
        completionHandler([.badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        logInfo("[PUSH] didReceive notification with userInfo: \(userInfo)")
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        logInfo("[FIREBASE] FCM Token: \(fcmToken ?? "unknown")")
        // Try to notify backend. It will make a check that notifications are enabled by user.
        NotificationsManager.shared.enableNotifications()
    }
}
