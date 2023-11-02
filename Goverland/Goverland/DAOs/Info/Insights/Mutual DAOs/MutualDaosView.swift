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
            LazyHStack(spacing: 12) {
                if dataSource.mutualDaos.isEmpty { // initial loading
                    ForEach(0..<3) { _ in
                        ShimmerDaoCardView()
                    }
                } else {
                    let count = dataSource.mutualDaos.count
                    ForEach(0..<dataSource.mutualDaos.count, id: \.self) { index in
                        let dao = dataSource.mutualDaos[index]
                        if index == count - 1 && dataSource.hasMore() {
                            if !dataSource.failedToLoad() { // try to paginate
                                ShimmerDaoCardView()
                                    .onAppear {
                                        dataSource.loadMore()
                                    }
                            } else { // retry pagination
                                //RetryLoadMoreCardView()
                            }
                        } else {
                            DaoCardView(dao: dao,
                                        onSelectDao: { dao in activeSheetManger.activeSheet = .daoInfo(dao); Tracker.track(.mutualDaosOpen) },
                                        onFollowToggle: { if $0 { Tracker.track(.mutualDaosFollowFromCard) } })
                        }
                    }
                }
            }
        }
    }
}
