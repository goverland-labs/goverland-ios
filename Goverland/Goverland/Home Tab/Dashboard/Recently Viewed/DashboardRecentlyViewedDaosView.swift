//
//  DashboardRecentlyViewedDaosView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-27.
//

import SwiftUI

struct DashboardRecentlyViewedDaosView: View {
    @EnvironmentObject private var activeSheetManger: ActiveSheetManager
    private let dataSource: RecentlyViewedDaosDataSource
    
    init(dataSource: RecentlyViewedDaosDataSource) {
        self.dataSource = dataSource
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(dataSource.recentlyViewedDaos) { dao in
                    RoundPictureView(image: dao.avatar, imageSize: 45)
                    
                }
            }
            .padding()
        }
        .background(Color.container)
        .cornerRadius(20)
        .padding(.horizontal)
        .onAppear() {
            dataSource.refresh()
        }
    }
}
