//
//  GroupedDaosView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-05.
//

import SwiftUI

struct GroupedDaosView: View {
    @ObservedObject var dataSource: GroupedDaosDataSource
    let displayCallToAction: Bool

    init(dataSource: GroupedDaosDataSource, displayCallToAction: Bool = false) {
        self.dataSource = dataSource
        self.displayCallToAction = displayCallToAction
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                if displayCallToAction {
                    Text("Get Updates for the DAOs you select.")
                        .font(.subheadlineRegular)
                        .foregroundColor(.textWhite)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                ForEach(DaoCategory.values) { category in
                    VStack(spacing: 8) {
                        HStack {
                            let total = dataSource.totalInCategory[category] ?? 0
                            Text(total != 0 ? "\(category.name) (\(total))" : category.name)
                                .font(.subheadlineSemibold)
                                .foregroundColor(.textWhite)
                            Spacer()
                            NavigationLink("See all", value: category)
                                .font(.subheadlineSemibold)
                                .foregroundColor(.primaryDim)
                        }
                        .padding(.top, 20)
                        DaoThreadForCategoryView(dataSource: dataSource, category: category)
                    }
                }
            }
        }
    }
}

fileprivate struct DaoThreadForCategoryView: View {
    @ObservedObject var dataSource: GroupedDaosDataSource
    let category: DaoCategory

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                if dataSource.categoryDaos[category] == nil { // initial loading
                    ForEach(0..<3) { _ in
                        ShimmerDaoCardView()
                    }
                } else {
                    let count = dataSource.categoryDaos[category]!.count
                    ForEach(0..<count, id: \.self) { index in
                        let dao = dataSource.categoryDaos[category]![index]
                        if index == count - 1 && dataSource.hasMore(category: category) {
                            if !dataSource.failedToLoad(category: category) { // try to paginate
                                ShimmerDaoCardView()
                                    .onAppear {
                                        dataSource.loadMore(category: category)
                                    }
                            } else { // retry pagination
                                RetryLoadMoreCardView(dataSource: dataSource, category: category)
                            }
                        } else {
                            DaoCardView(dao: dao)
                        }
                    }
                }
            }
        }
        .padding(.bottom, 20)
    }
}

fileprivate struct DaoCardView: View {
    let dao: Dao

    var body: some View {
        VStack {
            RoundPictureView(image: dao.image, imageSize: 90)
            VStack(spacing: 3) {
                Text(dao.name)
                    .fontWeight(.semibold)
                    .font(.headline)
                    .foregroundColor(.textWhite)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                Text("18.2K members")
                    .font(.сaption2Regular)
                    .foregroundColor(.textWhite60)
            }
            Spacer()
            FollowButtonView(isFollowing: dao.subscriptionMeta != nil, daoID: dao.id)
        }
        .frame(width: 130, height: 200)
        .padding(.vertical, 30)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.container))
    }
}

// TODO: implement design
fileprivate struct RetryLoadMoreCardView: View {
    let dataSource: GroupedDaosDataSource
    let category: DaoCategory

    var body: some View {
        Button("Load more") {
            dataSource.retryLoadMore(category: category)
        }
        .frame(width: 130)
    }
}

struct DaosGroupedByCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        GroupedDaosView(dataSource: GroupedDaosDataSource())
    }
}
