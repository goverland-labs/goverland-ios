//
//  MutualDaosView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-02.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

struct MutualDaosView: View {
    @StateObject private var dataSource: MutualDaosDataSource

    init(dao: Dao) {
        let dataSource = MutualDaosDataSource(dao: dao)
        _dataSource = StateObject(wrappedValue: dataSource)
    }

    var body: some View {
        VStack {
            GraphHeaderView(header: "Voters also participate in", subheader: "Other DAOs where voters of this DAO participate.", tooltipSide: .topLeft)

            if dataSource.failedToLoadInitialData {
                RefreshIcon {
                    dataSource.refresh()
                }
            } else if dataSource.mutualDaos?.isEmpty ?? false {
                Text("All voters are exclusive to this DAO")
                    .font(.body)
                    .foregroundStyle(Color.textWhite)
                    .padding()
            } else {
                MutualDaosScrollView(dataSource: dataSource)
                    .padding(.leading, 8)
                    .padding(.bottom, 16)
            }
        }
        .onAppear {
            if dataSource.mutualDaos?.isEmpty ?? true {
                dataSource.refresh()
            }
        }
    }
}

fileprivate struct MutualDaosScrollView: View {
    @StateObject var dataSource: MutualDaosDataSource
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                if dataSource.mutualDaos == nil { // initial loading
                    ForEach(0..<5) { _ in
                        ShimmerDaoCardView()
                    }
                } else {
                    let count = dataSource.mutualDaos!.count
                    ForEach(0..<count, id: \.self) { index in
                        let obj = dataSource.mutualDaos![index]
                        let dao = obj.dao
                        let percentage = Utils.numberWithPercent(from: obj.votersPercent)
                        DaoCardView(dao: dao,
                                    subheader: "\(percentage) voters",
                                    onSelectDao: { dao in activeSheetManager.activeSheet = .daoInfo(dao); Tracker.track(.daoInsightsMutualOpen) },
                                    onFollowToggle: { if $0 { Tracker.track(.daoInsightsMutualFollow) } })
                    }
                }
            }
        }
    }
}
