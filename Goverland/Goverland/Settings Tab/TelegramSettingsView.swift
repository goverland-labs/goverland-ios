//
//  TelegramSettingsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-31.
//

import SwiftUI

struct TelegramSettingsView: View {
    var body: some View {
        HStack {
            Image(systemName: "paperplane.circle")
                .foregroundColor(.primary)
            Button("Telegram", action: openTelegramApp)
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

struct TelegramSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TelegramSettingsView()
    }
}
