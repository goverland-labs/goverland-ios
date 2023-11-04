//
//  SettingsView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import Kingfisher
import StoreKit


enum SettingsScreen {
    case subscriptions
    case pushNofitications
    case about
    case helpUsGrow
    case partnership
    case advanced
}

struct SettingsView: View {
    @Binding var path: [SettingsScreen]

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section(header: Text("Goverland")) {
                    NavigationLink("My followed DAOs", value: SettingsScreen.subscriptions)
                    NavigationLink("Notifications", value: SettingsScreen.pushNofitications)
                }
                
                Section(header: Text("Contact Us")) {
                    TwitterSettingsView()
                    DiscordSettingsView()
                    MailSettingView()
                }
                
                Section {
                    NavigationLink("About", value: SettingsScreen.about)
                    NavigationLink("Help us grow", value: SettingsScreen.helpUsGrow)
                    NavigationLink("Partnership", value: SettingsScreen.partnership)
                    NavigationLink("Advanced", value: SettingsScreen.advanced)
                    LabeledContent("App version", value: Bundle.main.releaseVersionNumber!)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Settings")
                            .font(.title3Semibold)
                            .foregroundColor(Color.textWhite)
                    }
                }
            }
            .navigationDestination(for: SettingsScreen.self) { settingsScreen in
                switch settingsScreen {
                case .subscriptions: SubscriptionsView()
                case .pushNofitications: PushNotificationsSettingView()
                case .about: AboutSettingView()
                case .helpUsGrow: HelpUsGrowSettingView()
                case .partnership: PartnershipSettingView()
                case .advanced: AdvancedSettingView()
                }
            }
        }
        .onAppear() { Tracker.track(.screenSettings) }
    }
}

fileprivate struct PushNotificationsSettingView: View {
    @State private var notificationsEnabled = SettingKeys.shared.notificationsEnabled
    @State private var showAlert = false
    @State private var skipTrackingOnce = false

    var body: some View {
        List {
            Toggle("Receive updates from DAOs", isOn: $notificationsEnabled)
        }
        .onChange(of: notificationsEnabled) { toggleEnabled in
            NotificationsManager.shared.getNotificationsStatus { status in
                switch status {
                case .notDetermined:
                    if toggleEnabled {
                        Tracker.track(.settingsEnableGlbNotifications)
                        NotificationsManager.shared.requestUserPermissionAndRegister { granted in
                            DispatchQueue.main.async {
                                SettingKeys.shared.notificationsEnabled = granted
                                notificationsEnabled = granted
                            }
                        }
                    } else {
                        // should not happen
                        logError(GError.appInconsistency(reason: "Enabled notifications toggle without determined permission."))
                    }

                case .denied:
                    if toggleEnabled {
                        // Notifications are disabled in app settings
                        notificationsEnabled = false
                        showAlert = true
                    } else {
                        logInfo("Auto-disabled notifications toggle")
                    }
                default:
                    if toggleEnabled {
                        if !skipTrackingOnce {
                            Tracker.track(.settingsEnableGlbNotifications)
                        } else {
                            skipTrackingOnce = false
                        }
                        SettingKeys.shared.notificationsEnabled = true
                        NotificationsManager.shared.enableNotifications()
                    } else {
                        Tracker.track(.settingsDisableGlbNotifications)
                        NotificationsManager.shared.disableNotifications { disabled in
                            guard disabled else {
                                // Error will be displayed automatically if there was a networking issue
                                skipTrackingOnce = true
                                notificationsEnabled = true
                                return
                            }
                            SettingKeys.shared.notificationsEnabled = false
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Notifications Disabled"),
                message: Text("To receive notifications, enable them in your device's settings."),
                primaryButton: .default(Text("Open Settings"), action: showAppSettings),
                secondaryButton: .cancel()
            )
        }
        .onAppear() { Tracker.track(.screenNotifications) }
    }

    private func showAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(settingsURL)
    }
}

fileprivate struct AboutSettingView: View {
    var body: some View {
        List {
            HStack {
                Image("privacy-policy")
                    .foregroundColor(.primaryDim)
                    .frame(width: 30)
                Text("[Privacy Policy](http://goverland.xyz/privacy)")
                Spacer()
                Image(systemName: "arrow.up.right")
                    .foregroundColor(.textWhite40)
            }

            HStack {
                Image("term-service")
                    .foregroundColor(.primaryDim)
                    .frame(width: 30)
                Text("[Terms of Service](http://goverland.xyz/terms)")
                Spacer()
                Image(systemName: "arrow.up.right")
                    .foregroundColor(.textWhite40)
            }
        }
        .environment(\.openURL, OpenURLAction { url in
            openUrl(url)

            switch url.absoluteString {
            case "http://goverland.xyz/privacy": Tracker.track(.settingsOpenPrivacyPolicy)
            case "http://goverland.xyz/terms": Tracker.track(.settingsOpenTerms)
            default: break
            }
            
            return .handled
        })
        .accentColor(.textWhite)
        .onAppear() { Tracker.track(.screenAbout) }
    }
}

fileprivate struct HelpUsGrowSettingView: View {
    var body: some View {
        List{
            Button(action: {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
                Tracker.track(.settingsRateTheApp)
            }) {
                HStack {
                    Image("rate-app")
                        .foregroundColor(.primaryDim)
                        .frame(width: 30)
                    Text("Rate the App")
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .foregroundColor(.textWhite40)
                }
            }

            Button(action: {
                let tweetText = "Check out Goverland App by @goverland_xyz!"
                let tweetUrl = tweetText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                let twitterUrl = URL(string: "https://twitter.com/intent/tweet?text=\(tweetUrl ?? "")")

                if let url = twitterUrl {
                    openUrl(url)
                }

                Tracker.track(.settingsShareTweet)
            }) {
                HStack {
                    HStack {
                        Image("share-tweet")
                            .foregroundColor(.primaryDim)
                            .frame(width: 30)
                        Text("Share a tweet")
                        Spacer()
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.textWhite40)
                    }
                }
            }
        }
        .accentColor(.textWhite)
        .onAppear() { Tracker.track(.screenHelpUsGrow) }
    }
}

fileprivate struct AdvancedSettingView: View {
    @State private var accepted = false

    var body: some View {
        List {
            #if STAGE
            Section(header: Text("Debug")) {
                Button("RESET") {
                    SettingKeys.reset()
                    fatalError("Crash with Reset button")
                }
                .accentColor(.dangerText)

                Button("LOG ERROR") {
                    logError(GError.appInconsistency(reason: "Debug test error logging"))
                }
                .accentColor(.textWhite60)
            }
            #endif

            Section(header: Text("Share anonymized data")) {
                Toggle(isOn: $accepted) {
                    Text("Allow App to Track Activity")
                }
            }

            if let deviceId = UIDevice.current.identifierForVendor?.uuidString {
                Section(header: Text("Device Id")) {
                    LabeledContent(deviceId) {
                        Button {
                            UIPasteboard.general.string = deviceId
                            showToast("Copied")
                        } label: {
                            Image(systemName: "doc.on.doc")
                        }
                        .foregroundColor(.primaryDim)
                    }
                }
            }

            if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                Section(header: Text("Meta-info")) {
                    LabeledContent("Build number", value: buildNumber)
                }
            }
        }
        .onChange(of: accepted) { accepted in
            if !accepted {
                Tracker.track(.settingsDisableTracking)
            }
            SettingKeys.shared.trackingAccepted = accepted
        }
        .onAppear() {
            accepted = SettingKeys.shared.trackingAccepted
            Tracker.track(.screenAdvancedSettings)
        }
    }
}
