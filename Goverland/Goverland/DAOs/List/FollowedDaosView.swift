//
//  FollowedDaosView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-17.
//

import SwiftUI

struct FollowedDaosView: View {
    @ObservedObject var dataSource: FollowedDaosDataSource

    var body: some View {
        ScrollView(showsIndicators: false) {
            if dataSource.daos.isEmpty {
                Text("")
                    .onAppear() {
                        ErrorViewModel.shared.setErrorMessage("You are not currently following any DAO. Please perform a search to subscribe.")
                    }
                
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
        FollowedDaosView(dataSource: FollowedDaosDataSource())
    }
}
