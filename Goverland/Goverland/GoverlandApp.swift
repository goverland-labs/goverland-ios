//
//  GoverlandApp.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 15.12.22.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import Firebase
import SwiftData

let appContainer: ModelContainer = {
    do {
        return try ModelContainer(for: UserProfile.self)
    } catch {
        fatalError("Failed to create App container")
    }
}()

@main
struct GoverlandApp: App {
    @StateObject private var colorSchemeManager = ColorSchemeManager()
    @StateObject private var activeSheetManger = ActiveSheetManager()
    @Environment(\.scenePhase) private var scenePhase
    @Setting(\.authToken) private var authToken
    @Setting(\.unreadEvents) private var unreadEvents
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(colorSchemeManager)
                .environmentObject(activeSheetManger)
                .onAppear() {
                    colorSchemeManager.applyColorScheme()
                }
                .onOpenURL { url in
                    handleDeepLink(url)
                }
                .onChange(of: scenePhase) { _, newPhase in
                    switch newPhase {
                    case .inactive:
                        logInfo("[App] Did become inactive")
                    case .active:
                        logInfo("[App] Did enter foreground")

                        // Also called when closing system dialogue to enable push notifications.
                        if !authToken.isEmpty {
                            logInfo("[App] Auth Token: \(authToken)")
                            // If the app was not used for a while and a user opens it
                            // try to get a new counter for unread messages.
                            if TabManager.shared.selectedTab != .inbox {
                                // We make this check not to dismiss Cast Your Vote Success View
                                // Which can be done from InboxView
                                InboxDataSource.shared.refresh()
                            }
                        } else {
                            logInfo("[App] Auth Token is empty")
                            unreadEvents = 0
                        }
                    case .background:
                        logInfo("[App] Did enter background")
                    @unknown default: break
                    }
                }
                .sheet(item: $activeSheetManger.activeSheet) { item in
                    switch item {
                    case .signIn:
                        SignInView(source: .popover)
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
        .modelContainer(appContainer)
    }

    // MARK: - Universal & Deep links support

    private func handleDeepLink(_ url: URL) {
        logInfo("[App] Open via a link: \(url.absoluteString)")
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Setup logging
        GLogger.append(handler: SystemLogHandler())
        GLogger.append(handler: CrashlyticsLogHandler())

        // Setup App Tracking
        Tracker.append(handler: LogInfoTrackingHandler())
        Tracker.append(handler: FirebaseTrackingHandler())

        // Very important line of code. Do not remove it.
        Tracker.setTrackingEnabled(SettingKeys.shared.trackingAccepted)

        // Setup Firebase
        FirebaseConfig.setUp()

        // Run WalletConnect manager initializer that will configure WalletConnect required parameters.
        _ = WC_Manager.shared

        // Setup Push Notifications Manager
        NotificationsManager.shared.setUpMessaging(delegate: self)

        // Setup appearance
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.containerBright)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.textWhite)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.textWhite)], for: .normal)

        UITextView.appearance().textContainerInset = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)

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
        
//        // paired with NotificationService
//        switch response.actionIdentifier {
//        case "action1":
//            print("action 1 should be running")
//            break
//        case "action2":
//            print("action 2 should be running")
//            break
//        default:
//            print("unknowen action item")
//            break
//        }
        
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
