//
//  RecentlyViewedDaosListView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-27.
//

import SwiftUI

struct RecentlyViewedDaosListView: View {
    @StateObject var dataSource = RecentlyViewedDaosDataSource.dashboard
    
    var body: some View {
        Text("Recently Viewed Daos List \(dataSource.recentlyViewedDaos.count)")
    }
}
