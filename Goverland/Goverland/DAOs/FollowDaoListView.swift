//
//  FollowDaoListView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.05.23.
//

import SwiftUI

struct FollowDaoListView: View {
    let dataSource: DaoDataSource

    init(category: DaoCategory? = nil) {
        self.dataSource = DaoDataSource(category: category)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(dataSource.daos) { dao in
                FollowDaoListItemView(dao: dao)
            }
        }
    }
}

fileprivate struct FollowDaoListItemView: View {
    let dao: Dao
    var body: some View {
        HStack {
            RoundPictureView(image: dao.image, imageSize: 50)
            Text(dao.name)
            Spacer()
            FollowButtonView(buttonWidth: 110, buttonHeight: 35)
        }
        .padding(5)
        .listRowSeparator(.hidden)
    }
}

struct FollowDaoListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowDaoListView()
    }
}
