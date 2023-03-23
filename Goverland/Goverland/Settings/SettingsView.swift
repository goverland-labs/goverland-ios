//
//  SettingsView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI
import Kingfisher
import MessageUI

struct SettingsView: View {
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowingMailView = false
    @State private var isShowingMailAlertView = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink("Followed DAOs") {
                        FollowedDaoView()
                    }
                    NavigationLink("Notifications") {
                        PushNotificationsSettingView()
                    }
                    NavigationLink("Appearance") {
                        AppearanceSettingView()
                    }
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
                        .alert(isPresented: $isShowingMailAlertView) {
                            Alert(
                                title: Text("Our email address:"),
                                message: Text("contact@goverland.xyz")
                            )
                        }
                    }
                }
                .tint(.primary)
                
                
                Section {
                    NavigationLink("About") {
                        AboutSettingView()
                    }
                    NavigationLink("Help us grow") {
                        HelpUsGrowSettingView()
                    }
                    NavigationLink("Advanced") {
                        AdvancedSettingView()
                    }
                    LabeledContent("App version", value: Bundle.main.releaseVersionNumber!)
                }
            }
        }
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

fileprivate struct AppearanceSettingView: View {
    
    @EnvironmentObject var colorSchemeManager: ColorSchemeManager
    
    var body: some View {
        
        VStack {
            Picker("", selection: $colorSchemeManager.colorScheme) {
                Text("Default").tag(ColorSchemeType.unspecified)
                Text("Light").tag(ColorSchemeType.light)
                Text("Dark").tag(ColorSchemeType.dark)
            }
            .pickerStyle(.segmented)
            .padding()
            
            Spacer()
        }
        .navigationTitle("Color Scheme")
    }
}

fileprivate struct AboutSettingView: View {
    
    var body: some View {
        List {
            HStack {
                Image(systemName: "heart.square.fill")
                Text("[About us](http://goverland.xyz/about)")
            }
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
    }
}

fileprivate struct HelpUsGrowSettingView: View {
    var body: some View {
        Text("Help us grow")
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
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ColorSchemeManager())
    }
}
