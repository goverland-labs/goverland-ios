//
//  AppTabView.swift
//  DaoFeed
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct AppTabView: View {
    var body: some View {
        TabView {
            ActivityView()
                .tabItem {
                    Label("Activity", systemImage: "list.dash.header.rectangle")
                }

            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "globe.desk")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "person.circle")
                }
        }
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
