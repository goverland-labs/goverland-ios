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
import CoinbaseWalletSDK

let appContainer: ModelContainer = {
    do {
        return try ModelContainer(for: UserProfile.self, DaoTermsAgreement.self)
    } catch {
        fatalError("Failed to create App container")
    }
}()

@main
struct GoverlandApp: App {
    @StateObject private var colorSchemeManager = ColorSchemeManager()
    @StateObject private var activeSheetManager = ActiveSheetManager()
    @StateObject private var recommendedDaosDataSource = RecommendedDaosDataSource.shared
    @Environment(\.scenePhase) private var scenePhase
    @Setting(\.authToken) private var authToken
    @Setting(\.unreadEvents) private var unreadEvents
    @Setting(\.lastAttemptToPromotedPushNotifications) private var lastAttemptToPromotedPushNotifications
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(colorSchemeManager)
                .environmentObject(activeSheetManager)
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

                        // Fetch remote config values in case app was not used for a while
                        RemoteConfigManager.shared.fetchFirebaseRemoteConfig()

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

                        // Default session is 7 days. Not to force users re-create a new session with a wallet
                        // every week, we will try to extend session if a wallet supports it.
                        WC_Manager.extendSessionIfNeeded()

                    case .background:
                        logInfo("[App] Did enter background")

                    @unknown default: break
                    }
                }
                .sheet(item: $activeSheetManager.activeSheet) { item in
                    switch item {
                    case .signIn:
                        SignInView(source: .popover)

                    case .daoInfo(let dao):
                        PopoverNavigationViewWithToast {
                            DaoInfoView(dao: dao)
                        }

                    case .publicProfile(let address):
                        PopoverNavigationViewWithToast {
                            PublicUserProfileView(address: address)
                        }

                    case .daoVoters(let dao, let filteringOption):
                        PopoverNavigationViewWithToast {
                            AllDaoVotersListView(dao: dao, filteringOption: filteringOption)
                        }

                    case .proposalVoters(let proposal):
                        PopoverNavigationViewWithToast {
                            SnapshotAllVotesView(proposal: proposal)
                        }

                    case .followDaos:
                        PopoverNavigationViewWithToast {
                            AddSubscriptionView()
                        }

                    case .archive:
                        // If ArchiveView is places in NavigationStack, it brakes SwiftUI on iPhone
                        ArchiveView()

                    case .subscribeToNotifications:
                        EnablePushNotificationsView()

                    case .recommendedDaos(let daos):
                        let height = Utils.heightForDaosRecommendation(count: daos.count)
                        RecommendedDaosView(daos: daos) {
                            lastAttemptToPromotedPushNotifications = Date().timeIntervalSinceReferenceDate
                        }
                        .presentationDetents([.height(height), .large])
                    }
                }
                .onChange(of: recommendedDaosDataSource.recommendedDaos) { _, daos in
                    // We set recommendedDaos published property to nil
                    // every time we request recommended DAOs.
                    guard let daos else { return }
                    if !daos.isEmpty {
                        if activeSheetManager.activeSheet == nil {
                            activeSheetManager.activeSheet = .recommendedDaos(daos)
                        }
                    } else {
                        lastAttemptToPromotedPushNotifications = Date().timeIntervalSinceReferenceDate
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: .unauthorizedActionAttempt)) { notification in
                    // This approach is used on AppTabView and DaoInfoView
                    if activeSheetManager.activeSheet == nil {
                        activeSheetManager.activeSheet = .signIn
                    }
                }
                .onChange(of: lastAttemptToPromotedPushNotifications) { _, _ in
                    showEnablePushNotificationsIfNeeded(activeSheetManager: activeSheetManager)
                }
                .overlay {
                    ToastView()
                        .environmentObject(activeSheetManager)
                }
        }
        .modelContainer(appContainer)
    }

    // MARK: - Universal & Deep links support

    private func handleDeepLink(_ url: URL) {
        logInfo("[App] Open via a link: \(url.absoluteString)")

        if (try? CoinbaseWalletSDK.shared.handleResponse(url)) == true {
            logInfo("[CoinbaseWallet] Handled universal link")
            return
        }
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

        // Configure CoinbaseWalletSDK
        _ = CoinbaseWalletManager.shared

        // Setup Push Notifications Manager
        NotificationsManager.shared.setUpMessaging(delegate: self)

        // Setup appearance
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.containerBright)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.textWhite)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.textWhite)], for: .normal)

        UITextView.appearance().textContainerInset = UIEdgeInsets(
            top: Constants.horizontalPadding + 4,
            left: Constants.horizontalPadding,
            bottom: Constants.horizontalPadding + 4,
            right: Constants.horizontalPadding)

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

        if let pushId = userInfo["id"] as? String {
            NotificationsManager.shared.markPushNotificationAsClicked(pushId: pushId)
        }

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
        NotificationsManager.shared.enableNotificationsIfNeeded()
    }
}
