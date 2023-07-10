//
//  SettingsView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI
import Kingfisher
import StoreKit


struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Goverland")) {
                    NavigationLink("Followed DAOs") { SubscriptionsView() }
                    NavigationLink("Notifications") { PushNotificationsSettingView() }
                }
                
                Section(header: Text("Contact Us")) {
                    TwitterSettingsView()
                    DiscordSettingsView()
                    MailSettingView()
                }
                
                Section {
                    NavigationLink("About") { AboutSettingView() }
                    NavigationLink("Help us grow") { HelpUsGrowSettingView() }
                    NavigationLink("Partnership") { PartnershipSettingView() }
                    NavigationLink("Advanced") { AdvancedSettingView() }
                    LabeledContent("App version", value: Bundle.main.releaseVersionNumber!)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear() { Tracker.track(.screenSettings) }
    }
}

fileprivate struct PushNotificationsSettingView: View {
    @State private var notificationsEnabled = SettingKeys.shared.notificationsEnabled
    @State private var showAlert = false

    var body: some View {
        List {
            Toggle("Receive updates from DAOs", isOn: $notificationsEnabled)
        }
        .onChange(of: notificationsEnabled) { enabled in
            if enabled {
                Tracker.track(.settingsEnableGlbNotifications)
                NotificationsManager.shared.verifyGlobalNotificationSettingsEnabled { gloabalNotificationsEnabled in
                    if !gloabalNotificationsEnabled {
                        notificationsEnabled = false
                        showAlert = true
                    } else {
                        SettingKeys.shared.notificationsEnabled = true
                        NotificationsManager.shared.enableNotifications()
                    }
                }
            } else {
                Tracker.track(.settingsDisableGlbNotifications)
                NotificationsManager.shared.disableNotifications { disabled in
                    guard disabled else {
                        // Error will be displayed automatically
                        notificationsEnabled = true
                        return
                    }
                    SettingKeys.shared.notificationsEnabled = false
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
                    .foregroundColor(.primary)
                    .frame(width: 30)
                Text("[Privacy Policy](http://goverland.xyz/privacy)")
                Spacer()
                Image(systemName: "arrow.up.right")
                    .foregroundColor(.textWhite40)
            }
            HStack {
                Image("term-service")
                    .foregroundColor(.primary)
                    .frame(width: 30)
                Text("[Terms of Service](http://goverland.xyz/terms)")
                Spacer()
                Image(systemName: "arrow.up.right")
                    .foregroundColor(.textWhite40)
            }
        }
        .environment(\.openURL, OpenURLAction { url in
            UIApplication.shared.open(url)

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
                        .foregroundColor(.primary)
                        .frame(width: 30)
                    Text("Rate the App")
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .foregroundColor(.textWhite40)
                }
            }
            
            HStack {
                Image("share-tweet")
                    .foregroundColor(.primary)
                    .frame(width: 30)
                Text("Share a tweet")
                //TODO: Impl + tracking: message, body and the image (after branding is done)
                Spacer()
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.textWhite40)
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
            Section(header: Text("Debug")) {
                Button("RESET") {
                    SettingKeys.reset()
                    exit(0)
                }
                .accentColor(.primary)
            }
            Section(header: Text("Share anonymized data")) {
                Toggle(isOn: $accepted) {
                    Text("Allow App to Track Activity")
                }
            }
        }
        .onChange(of: accepted) { accepted in
            if !accepted {
                Tracker.track(.settingsDisableTracking)
            }
            Tracker.setTrackingEnabled(accepted)
        }
        .onAppear() {
            accepted = SettingKeys.shared.trackingAccepted
            Tracker.track(.screenAdvancedSettings)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ColorSchemeManager())
    }
}
