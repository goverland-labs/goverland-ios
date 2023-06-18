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
            if dataSource.daos.isEmpty {
                Text("No followed Daos, use search to find and subscribe")
            } else {
                VStack(spacing: 12) {
                    ForEach(dataSource.daos) { dao in
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
