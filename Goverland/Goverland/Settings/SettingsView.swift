//
//  SettingsView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Followed DAOs")
                    Text("Notifications")
                    Text("Appearance")
                }
                
                Section(header: Text("Contact Us")) {
                    Button("Twitter", action: openTwitterApp)
                    Button("Telegram", action: openTelegramApp)
                    Button("Email", action: openMailApp)
                    
                }
                
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
                    LabeledContent("App version", value: Bundle.main.releaseVersionNumber ?? "0.1.0")
                }
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

fileprivate struct AboutSettingView: View {
    var body: some View {
        List {
            Text("[About us](http://goverland.xyz/about)")
            Text("[Privacy Policy](http://goverland.xyz/privacy)")
            Text("[Terms of Service](http://goverland.xyz/terms)")
        }
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
                SettingKeys().onboardingFinished = false
                SettingKeys().termsAccepted = false
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
