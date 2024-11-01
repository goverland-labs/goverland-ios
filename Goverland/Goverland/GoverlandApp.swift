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
                        NotificationCenter.default.post(name: .appEnteredForeground, object: nil)

                        // Fetch remote config values in case app was not used for a while
                        RemoteConfigManager.shared.fetchFirebaseRemoteConfig()

                        // Also called when closing system dialogue to enable push notifications.
                        if !authToken.isEmpty {
                            logInfo("[App] Auth Token: \(authToken)")
                            // If the app was not used for a while and a user opens it
                            // try to get a new counter for unread messages.
                            InboxDataSource.shared.refresh()
                            // Refresh user achievementsExp
                            AchievementsDataSource.shared.refresh()
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

                    case .daoInfoById(let daoId):
                        PopoverNavigationViewWithToast {
                            DaoInfoView(daoId: daoId)
                        }

                    case .publicProfileById(let profileId):
                        PopoverNavigationViewWithToast {
                            PublicUserProfileView(profileId: profileId)
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

                    case .notifications:
                        PopoverNavigationViewWithToast {
                            InboxView()
                        }

                    case .archive:
                        PopoverNavigationViewWithToast {
                            ArchiveView()
                        }

                    case .subscribeToNotifications:
                        EnablePushNotificationsView()

                    case .recommendedDaos(let daos):
                        let height = Utils.heightForDaosRecommendation(count: daos.count)
                        RecommendedDaosView(daos: daos) {
                            lastAttemptToPromotedPushNotifications = Date().timeIntervalSinceReferenceDate
                        }
                        .presentationDetents([.height(height), .large])

                    case .daoDelegateProfileById(let daoId, let delegateId, let action):
                        PopoverNavigationViewWithToast {
                            DaoDelegateProfileView(daoId: daoId, delegateId: delegateId, action: action)
                        }

                    case .daoUserDelegate(let dao, let user):
                        DaoUserDelegationView(dao: dao, delegate: user)
                        
                    case .proposal(let proposalId):
                        PopoverNavigationViewWithToast {
                            SnapshotProposalView(proposalId: proposalId, isRootView: true)
                        }
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
                .onReceive(NotificationCenter.default.publisher(for: .proposalPushOpened)) { notification in
                    if let proposalIds = notification.object as? [String],
                        let proposalId = proposalIds.first
                    {
                        activeSheetManager.activeSheet = .proposal(proposalId)
                    }
                }
                .onChange(of: lastAttemptToPromotedPushNotifications) { _, _ in
                    showEnablePushNotificationsIfNeeded(activeSheetManager: activeSheetManager)
                }
                .overlay {
                    InfoAlertView()
                        .environmentObject(activeSheetManager)
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

        let pathComponents = url.pathComponents
        if pathComponents.count > 2 {
            switch pathComponents[1] {
            case "dao":
                let daoId = pathComponents[2]
                if pathComponents.count > 4 && pathComponents[3] == "delegate" {
                    // dao delegate info
                    let delegateId = pathComponents[4]
                    activeSheetManager.activeSheet = .daoDelegateProfileById(daoId: daoId, delegateId: delegateId, delegateAction: .delegate)
                } else {
                    // dao info
                    activeSheetManager.activeSheet = .daoInfoById(daoId)
                }
            case "proposals":
                let proposalId = pathComponents[2]
                activeSheetManager.activeSheet = .proposal(proposalId)
            case "profiles":
                let profileId = pathComponents[2]
                activeSheetManager.activeSheet = .publicProfileById(profileId)
            default:
                break
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Setup Firebase
        FirebaseConfig.setUp()

        // Setup logging
        GLogger.append(handler: SystemLogHandler())
        GLogger.append(handler: CrashlyticsLogHandler())

        // Setup App Tracking
        Tracker.append(handler: LogInfoTrackingHandler())
        Tracker.append(handler: FirebaseTrackingHandler())

        // Very important line of code. Do not remove it.
        Tracker.setTrackingEnabled(SettingKeys.shared.trackingAccepted)

        // Run WalletConnect manager initializer that will configure WalletConnect required parameters.
        _ = WC_Manager.shared

        // Configure CoinbaseWalletSDK
        _ = CoinbaseWalletManager.shared

        // Setup Push Notifications Manager
        NotificationsManager.shared.setUpMessaging(delegate: self)

        // Load App Versions
        WhatsNewDataSource.shared.loadData()

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

        if let proposals = userInfo["proposals"] as? [String] {
            NotificationCenter.default.post(name: .proposalPushOpened, object: proposals)
        }

        Tracker.track(.openPush)

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
