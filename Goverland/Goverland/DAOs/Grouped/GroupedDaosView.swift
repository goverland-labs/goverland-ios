//
//  GroupedDaosView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-05.
//

import SwiftUI

struct GroupedDaosView: View {
    @ObservedObject var dataSource: GroupedDaosDataSource
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    let callToAction: String?
    let bottomPadding: CGFloat

    let onSelectDaoFromGroup: ((Dao) -> Void)?
    let onSelectDaoFromCategoryList: ((Dao) -> Void)?
    let onSelectDaoFromCategorySearch: ((Dao) -> Void)?

    let onFollowToggleFromCard: ((_ didFollow: Bool) -> Void)?
    let onFollowToggleFromCategoryList: ((_ didFollow: Bool) -> Void)?
    let onFollowToggleFromCategorySearch: ((_ didFollow: Bool) -> Void)?

    let onCategoryListAppear: (() -> Void)?

    init(dataSource: GroupedDaosDataSource,

         callToAction: String? = nil,
         bottomPadding: CGFloat = 0,

         onSelectDaoFromGroup: ((Dao) -> Void)? = nil,
         onSelectDaoFromCategoryList: ((Dao) -> Void)? = nil,
         onSelectDaoFromCategorySearch: ((Dao) -> Void)? = nil,

         onFollowToggleFromCard: ((_ didFollow: Bool) -> Void)? = nil,
         onFollowToggleFromCategoryList: ((_ didFollow: Bool) -> Void)? = nil,
         onFollowToggleFromCategorySearch: ((_ didFollow: Bool) -> Void)? = nil,

         onCategoryListAppear: (() -> Void)? = nil
    ) {
        self.dataSource = dataSource

        self.callToAction = callToAction
        self.bottomPadding = bottomPadding

        self.onSelectDaoFromGroup = onSelectDaoFromGroup
        self.onSelectDaoFromCategoryList = onSelectDaoFromCategoryList
        self.onSelectDaoFromCategorySearch = onSelectDaoFromCategorySearch

        self.onFollowToggleFromCard = onFollowToggleFromCard
        self.onFollowToggleFromCategoryList = onFollowToggleFromCategoryList
        self.onFollowToggleFromCategorySearch = onFollowToggleFromCategorySearch

        self.onCategoryListAppear = onCategoryListAppear
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {                
                if let callToAction = callToAction {
                    Text(callToAction)
                        .font(.subheadlineRegular)
                        .foregroundColor(.textWhite)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
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
                        .padding(.top, 16)
                        .padding(.horizontal, 16)

                        DaoThreadForCategoryView(dataSource: dataSource,
                                                 category: category,
                                                 onSelectDao: onSelectDaoFromGroup,
                                                 onFollowToggle: onFollowToggleFromCard)
                            .padding(.leading, 8)
                            .padding(.top, 8)
                            .padding(.bottom, 16)
                    }
                }
                Spacer()
                    .frame(height: bottomPadding)
            }
        }
        .navigationDestination(for: DaoCategory.self) { category in
            FollowCategoryDaosListView(category: category,
                                       onSelectDaoFromList: onSelectDaoFromCategoryList,
                                       onSelectDaoFromSearch: onSelectDaoFromCategorySearch,
                                       onFollowToggleFromList: onFollowToggleFromCategoryList,
                                       onFollowToggleFromSearch: onFollowToggleFromCategorySearch,
                                       onCategoryListAppear: onCategoryListAppear)
        }
        .onReceive(NotificationCenter.default.publisher(for: .subscriptionDidToggle)) { _ in
            // refresh if some popover sheet is presented
            if activeSheetManager.activeSheet != nil {
                dataSource.refresh()
            }
        }
    }
}

fileprivate struct DaoThreadForCategoryView: View {
    @ObservedObject var dataSource: GroupedDaosDataSource
    let category: DaoCategory
    let onSelectDao: ((Dao) -> Void)?
    let onFollowToggle: ((_ didFollow: Bool) -> Void)?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                if dataSource.categoryDaos[category] == nil { // initial loading
                    ForEach(0..<5) { _ in
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
                            DaoCardView(dao: dao,                                        
                                        onSelectDao: onSelectDao,
                                        onFollowToggle: onFollowToggle)
                        }
                    }
                }
            }
        }
    }
}

struct GroupedDaosView_Previews: PreviewProvider {
    static var previews: some View {
        GroupedDaosView(dataSource: GroupedDaosDataSource())
    }
}
