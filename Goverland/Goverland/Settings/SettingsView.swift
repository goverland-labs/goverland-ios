//
//  SettingsView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI
import Kingfisher

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink("Followed DAOs") {
                        FollowedDaoView()
                    }
                    Text("Notifications")
                    Text("Appearance")
                }
                
                Section(header: Text("Contact Us")) {
                    HStack {
                        Image(systemName: "bird.fill")
                            .foregroundColor(.gray)
                        Button("Twitter", action: openTwitterApp)
                    }
                    HStack {
                        Image(systemName: "paperplane.circle")
                            .foregroundColor(.gray)
                        Button("Telegram", action: openTelegramApp)
                    }
                    HStack {
                        Image(systemName: "m.square")
                            .foregroundColor(.gray)
                        Button("Email", action: openMailApp)
                    }
                }
                .accentColor(.black)
                
                
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

    private func openMailApp() {
        
    }
}

fileprivate struct FollowedDaoView: View {
    @StateObject private var data = DaoDataService.data
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
        .accentColor(.black)
    }
}

fileprivate struct HelpUsGrowSettingView: View {
    var body: some View {
        Text("Help us grow")
    }
}

fileprivate struct AdvancedSettingView: View {
    var body: some View {
        VStack {
            Text("Would you like to reset the App?")
                .fontWeight(.bold)
            Text("this action will delete your local settings and closer the application")
                .padding(20)
            Button("RESET") {
                SettingKeys.reset()
                exit(0)
            }
            .ghostActionButtonStyle()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
