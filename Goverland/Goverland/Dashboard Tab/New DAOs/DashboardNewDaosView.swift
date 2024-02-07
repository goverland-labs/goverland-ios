//
//  DashboardNewDaosView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 18.10.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct DashboardNewDaosView: View {
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    @ObservedObject var dataSource = GroupedDaosDataSource.dashboard

    var body: some View {
        if dataSource.failedToLoadInitialData {
            RefreshIcon {
                dataSource.refresh()
            }
        } else {
            DaoThreadForCategoryView(dataSource: dataSource,
                                     category: DaoCategory.new,
                                     onSelectDao: { dao in activeSheetManager.activeSheet = .daoInfo(dao); Tracker.track(.dashNewDaoOpen) },
                                     onFollowToggle: { if $0 { Tracker.track(.dashNewDaoFollow) } })
            .padding(.leading, 8)
        }
    }
}
