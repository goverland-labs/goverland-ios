//
//  TwitterSettingsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-31.
//

import SwiftUI

struct TwitterSettingsView: View {
    var body: some View {
        HStack {
            Image(systemName: "bird")
                .foregroundColor(.primary)
            Button("Twitter", action: openTwitterApp)
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
}

struct TwitterSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TwitterSettingsView()
    }
}
