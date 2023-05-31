//
//  FollowDaoListView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.05.23.
//

import SwiftUI

// TODO: make FollowDaoListView as a reusable view without title
struct FollowDaoListView: View {
    @StateObject var dataSource = DaoDataSource()
    let title: String
    let category: DaoCategory

    init(category: DaoCategory) {
        self.title = "\(category.name) DAOs"
        self.category = category
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(dataSource.daos) { dao in
                FollowDaoListItemView(dao: dao)
            }
        }
        .onAppear {
            dataSource.loadData(category: category)
            Tracker.track(.followDaoListView)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(title)
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
        FollowDaoListView(category: .social)
    }
}
