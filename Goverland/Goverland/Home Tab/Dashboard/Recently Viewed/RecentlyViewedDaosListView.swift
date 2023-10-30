//
//  RecentlyViewedDaosListView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-27.
//

import SwiftUI

struct RecentlyViewedDaosListView: View {
    @StateObject var dataSource = RecentlyViewedDaosDataSource.dashboard
    
    let onSelectDaoFromList: ((Dao) -> Void)?
    let onFollowToggleFromList: ((_ didFollow: Bool) -> Void)?
    
    var body: some View {
        if !dataSource.failedToLoadInitialData {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    if dataSource.recentlyViewedDaos.isEmpty { // initial loading
                        ForEach(0..<5) { _ in
                            ShimmerDaoListItemView()
                        }
                    } else {
                        ForEach(0..<dataSource.recentlyViewedDaos.count, id: \.self) { index in
                            let dao = dataSource.recentlyViewedDaos[index]
                            DaoListItemView(dao: dao,
                                            subscriptionMeta: dao.subscriptionMeta,
                                            onSelectDao: onSelectDaoFromList,
                                            onFollowToggle: onFollowToggleFromList)
                        }
                    }
                }
            }
        } else {
            RetryInitialLoadingView(dataSource: dataSource)
        }
    }
}
