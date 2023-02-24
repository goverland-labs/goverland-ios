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
                    Text("Twitter")
                    Text("Telegram")
                    Text("Email")
                }
                
                Section {
                    Text("About")
                    Text("Help us grow")
                    NavigationLink("Advanced") {
                        AdvancedSettingView()
                    }
                    LabeledContent("App version", value: "0.1.0 (2)")
                }
            }
        }
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
