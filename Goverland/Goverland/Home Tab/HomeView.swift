//
//  HomeView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 04.10.23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var activeViewManager = ActiveHomeViewManager.shared

    var body: some View {
        switch activeViewManager.activeView {
        case .dashboard: DashboardView()
        case .inbox: InboxView()
        }
    }
}

#Preview {
    HomeView()
}
