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
    private let dao: Dao
    @StateObject private var dataSource: TopDaoVotersDataSource
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    init(dao: Dao) {
        self.dao = dao
        let dataSource = TopDaoVotersDataSource(dao: dao)
        _dataSource = StateObject(wrappedValue: dataSource)
    }
    
    var body: some View {
        GraphHeaderView(header: "Top 10 voters by average VP",
                        subheader: "Average voting power is calculated based on the last six months of user activity.",
                        tooltipSide: .topLeft)

        TopVotersView(dataSource: dataSource) {
            activeSheetManager.activeSheet = .allDaoVoters(dao)
        }
    }
}
