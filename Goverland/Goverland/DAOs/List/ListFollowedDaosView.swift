//
//  ListFollowedDaosView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-17.
//

import SwiftUI

struct ListFollowedDaosView: View {
    @ObservedObject var dataSource: ListFollowedDaosDataSource

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                if dataSource.nothingFound {
                    Text("Nothing found")
                } else if dataSource.searchResultDaos.isEmpty { // initial searching
                    ForEach(0..<3) { _ in
                        ShimmerDaoListItemView()
                    }
                } else {
                    ForEach(dataSource.searchResultDaos) { dao in
                        DaoListItemView(dao: dao)
                    }
                }
            }
        }
    }
}

struct ListDaosView_Previews: PreviewProvider {
    static var previews: some View {
        ListFollowedDaosView(dataSource: ListFollowedDaosDataSource())
    }
}
