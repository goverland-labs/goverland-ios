//
//  AboutSettingView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 08.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct AboutSettingView: View {
    var body: some View {
        List {
            Button(action: {
                Tracker.track(.settingsOpenPrivacyPolicy)
                if let openURL = URL(string: "http://goverland.xyz/privacy") {
                    openUrl(openURL)
                }
            }) {
                HStack {
                    Image("privacy-policy")
                        .foregroundStyle(Color.primaryDim)
                        .frame(width: 30)
                    Text("Privacy Policy")
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .foregroundStyle(Color.textWhite40)
                }
            }
            Button(action: {
                Tracker.track(.settingsOpenTerms)
                if let openURL = URL(string: "http://goverland.xyz/terms") {
                    openUrl(openURL)
                }
            }) {
                HStack {
                    Image("term-service")
                        .foregroundStyle(Color.primaryDim)
                        .frame(width: 30)
                    Text("Terms of Service")
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .foregroundStyle(Color.textWhite40)
                }
            }
        }
        .tint(.textWhite)
        .onAppear() { Tracker.track(.screenAbout) }
    }
}
