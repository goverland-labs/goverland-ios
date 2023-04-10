//
//  AppTabView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct AppTabView: View {
    var body: some View {
        TabView {
            Group {
                ActivityView()
                    .tabItem {
                        Image(systemName: "house.circle.fill")
                    }
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass.circle.fill")
                    }
                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape.circle.fill")
                    }
            }
        }
        .accentColor(.goverlandGreenPrimary)
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
