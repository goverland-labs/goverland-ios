//
//  DashboardNewDaosView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 18.10.23.
//

import SwiftUI

struct DashboardNewDaosView: View {
    @EnvironmentObject private var activeSheetManger: ActiveSheetManager
    @ObservedObject var dataSource = GroupedDaosDataSource.dashboard

    var body: some View {
        if dataSource.failedToLoadInitialData {
            RefreshIcon {
                dataSource.refresh()
            }
        } else {
            DaoThreadForCategoryView(dataSource: dataSource,
                                     category: DaoCategory.new,
                                     onSelectDao: { dao in activeSheetManger.activeSheet = .daoInfo(dao); Tracker.track(.dashNewDaoOpen) },
                                     onFollowToggle: { if $0 { Tracker.track(.dashNewDaoFollow) } })
            .padding(.leading, 8)
            .padding(.bottom, 16)
        }
    }
}
