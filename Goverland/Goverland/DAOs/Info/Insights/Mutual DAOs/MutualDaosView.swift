//
//  MutualDaosView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-02.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

struct MutualDaosView: View {
    @EnvironmentObject private var activeSheetManger: ActiveSheetManager
    @StateObject private var dataSource: MutualDaosDataSource

    init(dao: Dao) {
        let dataSource = MutualDaosDataSource(dao: dao)
        _dataSource = StateObject(wrappedValue: dataSource)
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                if dataSource.mutualDaos.isEmpty { // initial loading
                    ForEach(0..<3) { _ in
                        ShimmerDaoCardView()
                    }
                } else {
                    let count = dataSource.mutualDaos.count
                    ForEach(0..<count, id: \.self) { index in
                        let dao = dataSource.mutualDaos[index].dao
                        DaoCardView(dao: dao,
                                    onSelectDao: { dao in activeSheetManger.activeSheet = .daoInfo(dao); Tracker.track(.daoInsightsMutualOpen) },
                                    onFollowToggle: { if $0 { Tracker.track(.daoInsightsMutualFollow) } })
                    }
                }
            }
        }
    }
}
