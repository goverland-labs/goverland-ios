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
                case .inbox:
                    inboxViewId = UUID()
                    InboxDataSource.shared.refresh()
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
    @Published var inboxViewId = UUID()
    
    static let shared = TabManager()
    
    private init() {}
}

struct AppTabView: View {
    @StateObject private var tabManager = TabManager.shared
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    @Setting(\.unreadEvents) private var unreadEvents
    @Setting(\.lastPromotedPushNotificationsTime) private var lastPromotedPushNotificationsTime
    @Setting(\.notificationsEnabled) private var notificationsEnabled
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
            
            // Don't display Inbox tab for signed out users
            if !authToken.isEmpty {
                // The magic below is to simulate view update by view id.
                // Unfortunatly when using here `.id(tabManager.inboxViewId)` it crashes the app
                if tabManager.inboxViewId == currentInboxViewId {
                    InboxView()
                        .tabItem {
                            Label("Inbox", image: tabManager.selectedTab == .inbox ? "inbox-active" : "inbox-inactive")
                        }
                        .toolbarBackground(.visible, for: .tabBar)
                        .tag(TabManager.Tab.inbox)
                        .badge(unreadEvents)
                } else {
                    Spacer()
                        .tabItem {
                            Label("Inbox", image: tabManager.selectedTab == .inbox ? "inbox-active" : "inbox-inactive")
                        }
                        .onAppear {
                            currentInboxViewId = tabManager.inboxViewId
                        }
                        .toolbarBackground(.visible, for: .tabBar)
                        .tag(TabManager.Tab.inbox)
                        .badge(unreadEvents)
                }
            }
            
            SearchView()
                .tabItem {
                    Label("Explore", image: tabManager.selectedTab == .search ? "search-active" : "search-inactive")
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
        .onReceive(NotificationCenter.default.publisher(for: .subscriptionDidToggle)) { notification in
            // TODO: check if we can make it better with macros

            // This approach is used on AppTabView, DaoInfoView and AddSubscriptionView
            guard let subscribed = notification.object as? Bool, subscribed else { return }
            // A user followed a DAO. Offer to subscribe to Push Notifications every two months if a user is not subscribed.
            let now = Date().timeIntervalSinceReferenceDate

            if now - lastPromotedPushNotificationsTime > ConfigurationManager.enablePushNotificationsRequestInterval && !notificationsEnabled {
                // don't promore if some active sheet already displayed
                if activeSheetManager.activeSheet == nil {
                    lastPromotedPushNotificationsTime = now
                    activeSheetManager.activeSheet = .subscribeToNotifications
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .unauthorizedActionAttempt)) { notification in
            // This approach is used on AppTabView and DaoInfoView
            if activeSheetManager.activeSheet == nil {
                activeSheetManager.activeSheet = .signIn
            }
        }
    }
}
