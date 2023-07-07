//
//  DaoSearchListView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 07.06.23.
//

import SwiftUI

struct DaosSearchListView: View {
    @ObservedObject var dataSource: GroupedDaosDataSource
    let onSelectDao: ((Dao) -> Void)?
    let onFollowToggle: ((Bool) -> Void)?

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                if dataSource.nothingFound {
                    Text("Nothing found")
                        .font(.body)
                        .foregroundColor(.textWhite)
                        .padding(.top, 16)
                } else if dataSource.searchResultDaos.isEmpty { // initial searching
                    ForEach(0..<3) { _ in
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
