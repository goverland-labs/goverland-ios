//
//  RecentlyViewedDaosListView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-27.
//

import SwiftUI

struct RecentlyViewedDaosListView: View {
    let dataSource: RecentlyViewedDaosDataSource
    var body: some View {
        Text("Recently Viewed Daos List \(dataSource.recentlyViewedDaos.count)")
    }
}
