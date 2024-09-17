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
    @Binding private var filteringOption: DatesFiltetingOption
    @StateObject private var dataSource: TopDaoVotersDataSource
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    init(dao: Dao, filteringOption: Binding<DatesFiltetingOption>) {
        _filteringOption = filteringOption
        let dataSource = TopDaoVotersDataSource(dao: dao, filteringOption: filteringOption.wrappedValue)
        _dataSource = StateObject(wrappedValue: dataSource)
    }
    
    var body: some View {
        GraphHeaderView(header: "Top 10 voters by average VP",
                        subheader: "Average voting power is calculated based on the user activity during the selected period.")

        TopVotersView(filteringOption: $filteringOption, dataSource: dataSource, showFilters: true) {
            activeSheetManager.activeSheet = .daoVoters(dataSource.dao, dataSource.selectedFilteringOption)
        }
        .onChange(of: filteringOption) { _, newValue in
            logInfo("[App] TopDaoVotersView filteringOption: \(newValue)")
            dataSource.selectedFilteringOption = newValue
        }
    }
}
