//
//  TopDaoVotersView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-07.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI
import Charts

struct TopDaoVotersView: View {
    @StateObject private var dataSource: TopDaoVotersDataSource
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    init(dao: Dao) {
        let dataSource = TopDaoVotersDataSource(dao: dao)
        _dataSource = StateObject(wrappedValue: dataSource)
    }
    
    var body: some View {
        GraphHeaderView(header: "Top 10 voters by average VP",
                        subheader: "Average voting power is calculated based on the user activity during the selected period.")

        TopVotersView(dataSource: dataSource, showFilters: true) {
            activeSheetManager.activeSheet = .daoVoters(dataSource.dao, dataSource.selectedFilteringOption)
        }
    }
}
