//
//  AppTabView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

class TabManager: ObservableObject {
    enum Tab {
        case home
        case search
        case settings
    }

    @Published var selectedTab: Tab = .home {
        didSet {
            // for now this is the only way we found to force redraw cycle of views.
            // Using `.id` modifier on Tab Views causes crashes. It seems like a SwiftUI bug.
            // Re-evaluate it later.
            if selectedTab == oldValue {
                switch selectedTab {
                case .home:
                    ActiveHomeViewManager.shared.activeView = .dashboard
                    DashboardView.refresh()
                case .search:
                    SearchModel.shared.refresh()
                    TopProposalsDataSource.search.refresh()
                case .settings:
                    settingsPath = [SettingsScreen]()
                }
            }
        }
    }

    @Published var settingsPath = [SettingsScreen]()

    static let shared = TabManager()

    private init() {}
}

struct AppTabView: View {
    @StateObject private var tabManager = TabManager.shared
    @Setting(\.unreadEvents) var unreadEvents

    var body: some View {
        TabView(selection: $tabManager.selectedTab) {
            HomeView()
                .tabItem {
                    Image(tabManager.selectedTab == .home ? "inbox-active" : "inbox")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .tag(TabManager.Tab.home)
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
        .accentColor(.textWhite)
    }
}
