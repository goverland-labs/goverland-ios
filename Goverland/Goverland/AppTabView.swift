//
//  AppTabView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct AppTabView: View {
    @State private var selectedTab = 1
    @Setting(\.unreadEvents) var unreadEvents
    
    var body: some View {
        TabView(selection: $selectedTab) {
            InboxView()
                .tabItem {
                    Image(selectedTab == 1 ? "inbox-active" : "inbox")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .tag(1)
                .badge(unreadEvents)

            SearchView()
                .tabItem {
                    Image(selectedTab == 2 ? "search-active" : "search")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .tag(2)

            SettingsView()
                .tabItem {
                    Image(selectedTab == 3 ? "settings-active" : "settings")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .tag(3)
        }
        .accentColor(.primary)
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
