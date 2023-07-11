//
//  AppTabView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

class TabManager: ObservableObject {
    @Published var selectedTab: Tab = .inbox
    @Published var settingsPath = [SettingsScreen]()

    static let shared = TabManager()

    private init() {}

    enum Tab {
        case inbox
        case search
        case settings
    }
}

struct AppTabView: View {
    @StateObject private var tabManager = TabManager.shared
    @Setting(\.unreadEvents) var unreadEvents
    
    var body: some View {
        TabView(selection: $tabManager.selectedTab) {
            InboxView()
                .tabItem {
                    Image(tabManager.selectedTab == .inbox ? "inbox-active" : "inbox")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .tag(TabManager.Tab.inbox)
                .badge(unreadEvents)

            SearchView()
                .tabItem {
                    Image(tabManager.selectedTab == .search ? "search-active" : "search")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .tag(TabManager.Tab.search)

            SettingsView(path: $tabManager.settingsPath)
                .tabItem {
                    Image(tabManager.selectedTab == .settings ? "settings-active" : "settings")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .tag(TabManager.Tab.settings)
        }
        .accentColor(.primary)
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
