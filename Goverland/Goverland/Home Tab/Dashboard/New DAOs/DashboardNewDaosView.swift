//
//  DashboardNewDaosView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 18.10.23.
//

import SwiftUI

struct DashboardNewDaosView: View {
    @EnvironmentObject private var activeSheetManger: ActiveSheetManager

    var body: some View {
        DaoThreadForCategoryView(dataSource: GroupedDaosDataSource.dashboard,
                                 category: DaoCategory.new,
                                 onSelectDao: { dao in activeSheetManger.activeSheet = .daoInfo(dao); Tracker.track(.dashNewDaoOpen) },
                                 onFollowToggle: { if $0 { Tracker.track(.dashNewDaoFollow) } })
            .padding(.leading, 8)
            .padding(.bottom, 16)
    }
}
