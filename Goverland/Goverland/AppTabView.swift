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
        case profile
    }
    
    @Published var selectedTab: Tab = .home {
        didSet {
            // for now this is the only way we found to force redraw cycle of views.
            // Using `.id` modifier on Tab Views causes crashes. It seems like a SwiftUI bug.
            // Re-evaluate it later.
            if selectedTab == oldValue {
                switch selectedTab {
                case .home:                    
                    DashboardView.refresh()
                    dashboardPath = NavigationPath()
                case .search:
                    SearchModel.shared.refresh()
                    GroupedDaosDataSource.search.refresh()
                case .profile:
                    profilePath = [ProfileScreen]()
                }
            }
        }
    }
    
    @Published var profilePath = [ProfileScreen]()
    @Published var dashboardPath = NavigationPath()

    static let shared = TabManager()
    
    private init() {}
}

struct AppTabView: View {
    @StateObject private var tabManager = TabManager.shared
    @Setting(\.authToken) private var authToken

    @State var currentInboxViewId: UUID?
    
    var body: some View {
        TabView(selection: $tabManager.selectedTab) {
            DashboardView(path: $tabManager.dashboardPath)
                .tabItem {
                    Label("Home", image: tabManager.selectedTab == .home ? "home-active" : "home-inactive")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .tag(TabManager.Tab.home)            
            
            SearchView()
                .tabItem {
                    Label("Search", image: tabManager.selectedTab == .search ? "search-active" : "search-inactive")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .tag(TabManager.Tab.search)
            
            ProfileView(path: $tabManager.profilePath)
                .tabItem {
                    Label("Profile", image: tabManager.selectedTab == .profile ? "profile-active" : "profile-inactive")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .tag(TabManager.Tab.profile)
        }
        .id(authToken) // to force proper tab bar refresh, otherwise an exception appears on sign in/sign out
        .tint(.textWhite)
    }
}
