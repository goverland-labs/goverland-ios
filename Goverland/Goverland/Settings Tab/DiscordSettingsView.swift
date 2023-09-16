//
//  DiscordSettingsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-31.
//

import SwiftUI

struct DiscordSettingsView: View {
    var body: some View {
        HStack {
            Image("discord")
                .foregroundColor(.primary)
                .frame(width: 30)
            Button("Discord", action: openDiscordApp)
            Spacer()
            Image(systemName: "arrow.up.right")
                .foregroundColor(.textWhite40)
        }
        .accentColor(.textWhite)
    }
    
    private func openDiscordApp() {
        let url = URL(string: "https://discord.gg/uerWdwtGkQ")!
        UIApplication.shared.open(url)
        Tracker.track(.settingsOpenDiscord)
    }
}

struct DiscordSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DiscordSettingsView()
    }
}
