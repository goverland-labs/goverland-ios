//
//  SettingsView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI
import Kingfisher
import StoreKit

enum SettingsActiveSheet: Identifiable {
    case followDaos, daoInfo(Dao)

    var id: Int {
        switch self {
        case .followDaos:
            return 0
        case .daoInfo:
            return 1
        }
    }
}

struct SettingsView: View {
    @State private var activeSheet: SettingsActiveSheet?

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Goverland")) {
                    NavigationLink("Followed DAOs") {
                        SubscriptionsView(activeSheet: $activeSheet)
                    }
                    NavigationLink("Notifications") {
                        PushNotificationsSettingView()
                    }
                }
                
                Section(header: Text("Contact Us")) {
                    TwitterSettingsView()
                    TelegramSettingsView()
                    DiscordSettingsView()
                    MailSettingView()
                }
                .tint(.primary)
                
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
        .onReceive(NotificationCenter.default.publisher(for: .didSelectShowDaoInfo)) { notification in
            if let dao = notification.object as? Dao {
                activeSheet = .daoInfo(dao)
            }
        }
        .sheet(item: $activeSheet) { item in
            NavigationStack {
                switch item {
                case .followDaos:
                    AddSubscriptionView()
                case .daoInfo(let dao):
                    DaoInfoView(dao: dao)
                }
            }
            .accentColor(.primary)
        }
        .onAppear() { Tracker.track(.settingsView) }
    }
}

fileprivate struct PushNotificationsSettingView: View {
    @State private var isReceiveUpdates = false
    var body: some View {
        VStack {
            Toggle("Receive updates from followed DAOs", isOn: $isReceiveUpdates)
            Spacer()
        }
        .padding()
        .onAppear() {Tracker.track(.settingsPushNotificationsView) }
    }
}

fileprivate struct AboutSettingView: View {
    var body: some View {
        List {
            HStack {
                Image(systemName: "lock.fill")
                Text("[Privacy Policy](http://goverland.xyz/privacy)")
            }
            HStack {
                Image(systemName: "doc.badge.gearshape")
                Text("[Terms of Service](http://goverland.xyz/terms)")
            }
        }
        .foregroundColor(.gray)
        .tint(.primary)
        .onAppear() {Tracker.track(.settingsAboutView) }
    }
}

fileprivate struct PartnershipSettingView: View {
    var body: some View {
        List {
            Text("[Partnership](http://www.goverland.xyz/partnership)")
        }
    }
}

fileprivate struct HelpUsGrowSettingView: View {
    var body: some View {
        List{
            Button(action: {
                if let scene = UIApplication.shared.windows.first?.windowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }) {
                HStack {
                    Image(systemName: "star.bubble")
                    Text("Rate the App")
                }
            }
            
            HStack {
                Image(systemName: "shareplay")
                Text("Share a tweet") //TODO: message, body and the image (after branding is done)
            }
        }
        .onAppear() {Tracker.track(.settingsHelpUsGrowView) }
    }
        
}

fileprivate struct AdvancedSettingView: View {
    @Setting(\.trackingAccepted) var trackingAccepted
    @State private var isTrackActivity = false
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
                Toggle(isOn: $isTrackActivity) {
                        Text("Allow App to Track Activity")
                }
                .onChange(of: isTrackActivity) { isTrackerOn in
                    trackingAccepted = isTrackerOn
                    Tracker.setTrackingEnabled(isTrackerOn)
                }
            }
        }
        .onAppear() {
            isTrackActivity = trackingAccepted
            Tracker.track(.settingsAdvancedView)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ColorSchemeManager())
    }
}
