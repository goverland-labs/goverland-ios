//
//  DaoSearchListView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 07.06.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct DaosSearchListView: View {
    @ObservedObject var dataSource = DaosSearchDataSource.shared
    let onSelectDao: ((Dao) -> Void)?
    let onFollowToggle: ((_ didFollow: Bool) -> Void)?

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                if dataSource.nothingFound {
                    Text("Nothing found")
                        .font(.body)
                        .foregroundStyle(Color.textWhite)
                        .padding(.top, 16)
                } else if dataSource.searchResultDaos.isEmpty { // initial searching
                    ForEach(0..<7) { _ in
                        ShimmerDaoListItemView()
                    }
                } else {
                    ForEach(dataSource.searchResultDaos) { dao in
                        DaoListItemView(dao: dao,
                                        subscriptionMeta: dao.subscriptionMeta,
                                        onSelectDao: onSelectDao,
                                        onFollowToggle: onFollowToggle)
                    }
                }
            }
        }
    }
}
