//
//  SettingsView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI
import Kingfisher
import MessageUI
import StoreKit

struct SettingsView: View {
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowingMailView = false
    @State private var isShowingMailAlertView = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink("Followed DAOs") { FollowedDaoView() }
                    NavigationLink("Notifications") { PushNotificationsSettingView() }
                }
                
                Section(header: Text("Contact Us")) {
                    HStack {
                        Image(systemName: "bird")
                            .foregroundColor(.primary)
                        Button("Twitter", action: openTwitterApp)
                    }
                    HStack {
                        Image(systemName: "paperplane.circle")
                            .foregroundColor(.primary)
                        Button("Telegram", action: openTelegramApp)
                    }
                    HStack {
                        Image(systemName: "gamecontroller")
                            .foregroundColor(.primary)
                        Button("Discord", action: openDiscordApp)
                    }
                    HStack {
                        Image(systemName: "m.square")
                            .foregroundColor(.primary)
                        Button("Email", action: {
                            if !MFMailComposeViewController.canSendMail() {
                                isShowingMailAlertView.toggle()
                            } else {
                                isShowingMailView.toggle()
                            }
                        })
                        .sheet(isPresented: $isShowingMailView) {
                            MailSendingView(result: $result)
                        }
                        .alert(isPresented: $isShowingMailAlertView,
                               content: GetSettingsEmailAddressAlert)
                    }
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
        }
        .onAppear() { Tracker.track(.settingsView) }
    }
    
    private func openTwitterApp() {
        let appURL = URL(string: "twitter://user?screen_name=goverland_xyz")!
        let webURL = URL(string: "https://twitter.com/goverland_xyz")!
        
        if UIApplication.shared.canOpenURL(appURL as URL) {
            UIApplication.shared.open(appURL)
        } else {
            UIApplication.shared.open(webURL)
        }
    }

    private func openTelegramApp() {
        let appURL = URL(string: "tg://resolve?domain=goverland_support")!
        let webURL = NSURL(string: "https://t.me/goverland_support")!
        
        if UIApplication.shared.canOpenURL(appURL as URL) {
            UIApplication.shared.open(appURL)
        } else {
            UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
        }
    }
    
    private func openDiscordApp() {
        guard let appURL = URL(string: "") else { return }
        guard let webURL = NSURL(string: "") else { return }
        
        if UIApplication.shared.canOpenURL(appURL as URL) {
            UIApplication.shared.open(appURL)
        } else {
            UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
        }
    }
    
    private func GetSettingsEmailAddressAlert() -> Alert {
        Alert(
            title: Text("Our email address:"),
            message: Text("contact@goverland.xyz"),
            primaryButton: .default(Text("Copy"), action: {
                UIPasteboard.general.string = "contact@goverland.xyz"
            }),
            secondaryButton: .cancel()
        )
    }
}

fileprivate struct FollowedDaoView: View {
    @StateObject private var data = DaoDataService()
    var body: some View {
        List {
            ForEach(data.daoGroups[.social] ?? []) { dao in
                HStack {
                    KFImage(dao.image)
                        .placeholder {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(.gray)
                        }
                        .resizable()
                        .setProcessor(ResizingImageProcessor(referenceSize: CGSize(width: 30, height: 30), mode: .aspectFill))
                        .frame(width: 30, height: 30)
                        .cornerRadius(15)
                    
                    Text(dao.name)
                    Spacer()
                    FollowingButtonView()
                }
            }
        }
        .onAppear() {Tracker.track(.settingsFollowDaoView) }
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

fileprivate struct FollowingButtonView: View {
    @State private var didTap: Bool = true
    var body: some View {
        Button(action: { didTap.toggle() }) {
            Text(didTap ? "Following" : "Follow")
        }
        .frame(width: 100, height: 30, alignment: .center)
        .foregroundColor(didTap ? .blue : .white)
        .fontWeight(.medium)
        .background(didTap ? Color("followButtonColorActive") : Color.blue)
        .cornerRadius(5)
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
