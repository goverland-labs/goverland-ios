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
            HStack {
                Text("Voters also participate in")
                    .font(.title3Semibold)
                    .foregroundColor(.textWhite)
                    .padding([.top, .horizontal])
                Spacer()
            }

            if dataSource.failedToLoadInitialData {
                RefreshIcon {
                    dataSource.refresh()
                }
            } else {
                MutualDaosScrollView(dataSource: dataSource)
                    .padding(.leading, 8)
            }
        }
        .onAppear {
            if dataSource.mutualDaos.isEmpty {
                dataSource.refresh()
            }
        }
    }
}

fileprivate struct MutualDaosScrollView: View {
    @StateObject var dataSource: MutualDaosDataSource

    /// This view should have own active sheet manager as it is already presented in a popover
    @StateObject private var activeSheetManager = ActiveSheetManager()

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                if dataSource.mutualDaos.isEmpty { // initial loading
                    ForEach(0..<5) { _ in
                        ShimmerDaoCardView()
                    }
                } else {
                    let count = dataSource.mutualDaos.count
                    ForEach(0..<count, id: \.self) { index in
                        let obj = dataSource.mutualDaos[index]
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
        .sheet(item: $activeSheetManager.activeSheet) { item in
            NavigationStack {
                switch item {
                case .daoInfo(let dao):
                    DaoInfoView(dao: dao)
                default:
                    // should not happen
                    EmptyView()
                }
            }
            .accentColor(.textWhite)
            .overlay {
                ToastView()
            }
        }
    }
}
