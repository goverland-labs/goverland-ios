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

@MainActor
let appContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: AppSettings.self, UserProfile.self)

        var fetchDescriptor = FetchDescriptor<AppSettings>()
        fetchDescriptor.fetchLimit = 1

        if try container.mainContext.fetch(fetchDescriptor).count > 0 {
            return container
        } else {
            container.mainContext.insert(AppSettings())
            return container
        }
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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(colorSchemeManager)
                .environmentObject(activeSheetManger)
                .onAppear() {
                    colorSchemeManager.applyColorScheme()
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
                            InboxDataSource.shared.refresh()
                        } else {
                            logInfo("[App] Auth Token is empty")
                        }
                    case .background:
                        logInfo("[App] Did enter background")
                    @unknown default: break
                    }
                }
                .sheet(item: $activeSheetManger.activeSheet) { item in
                    switch item {
                    case .signIn:
                        SignInView()
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
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Setup App Tracking
        Tracker.append(handler: ConsoleTrackingHandler())
        Tracker.append(handler: FirebaseTrackingHandler())

        // Very important line of code. Do not remove it.
        setupTracking()

        // Setup Firebase
        FirebaseConfig.setUp()

        // Run WalletConnect manager initializer that will configure WalletConnect required parameters.
        _ = WC_Manager.shared

        // Setup Push Notifications Manager
        NotificationsManager.shared.setUpMessaging(delegate: self)

        return true
    }

    private func setupTracking() {
        var fetchDescriptor = FetchDescriptor<AppSettings>()
        fetchDescriptor.fetchLimit = 1
        if let appSettings = try? appContainer.mainContext.fetch(fetchDescriptor).first {
            logInfo("[App] Set tracking to \(appSettings.trackingAccepted)")
            Tracker.setTrackingEnabled(appSettings.trackingAccepted)
        } else {
            fatalError("Failed to fetch AppSettings")
        }
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
