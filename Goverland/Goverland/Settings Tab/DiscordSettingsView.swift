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
}

struct DiscordSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DiscordSettingsView()
    }
}
