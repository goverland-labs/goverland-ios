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
        case inbox
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
                    // TODO: jump to root path
                    DashboardView.refresh()
                case .inbox:
                    // TODO: jump to root path
                    InboxDataSource.shared.refresh()
                case .search:
                    SearchModel.shared.refresh()
                    // TODO: now DAOs is a default tab
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
            DashboardView()
                .tabItem {
                    Image(tabManager.selectedTab == .home ? "home-active" : "home-inactive")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .tag(TabManager.Tab.home)

            InboxView()
                .tabItem {
                    Image(tabManager.selectedTab == .inbox ? "inbox-active" : "inbox-inactive")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .tag(TabManager.Tab.inbox)
                .badge(unreadEvents)

            SearchView()
                .tabItem {
                    Image(tabManager.selectedTab == .search ? "search-active" : "search-inactive")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .tag(TabManager.Tab.search)

            SettingsView(path: $tabManager.settingsPath)
                .tabItem {
                    Image(tabManager.selectedTab == .settings ? "settings-active" : "settings-inactive")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .tag(TabManager.Tab.settings)
        }
        .accentColor(.textWhite)
    }
}
