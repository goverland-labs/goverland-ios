//
//  DelegatesFullListView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 27.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

struct DelegatesFullListView: View {
    @StateObject var dataSource: DelegatesFullListDataSource
    let dao:Dao

    private var searchPrompt: String {
        if let total = dataSource.total {
            let totalStr = Utils.formattedNumber(Double(total))
            return "Search for \(totalStr) delegates"
        }
        return ""
    }

    init(dao: Dao) {
        self.dao = dao
        _dataSource = StateObject(wrappedValue: DelegatesFullListDataSource(dao: dao))
    }
    
    var body: some View {
        _DelegatesListView(dataSource: dataSource)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(dao.name)
            .searchable(text: $dataSource.searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: searchPrompt)
            .onAppear {
                dataSource.refresh()
            }
    }
}

fileprivate struct _DelegatesListView: View {
    @ObservedObject var dataSource: DelegatesFullListDataSource
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    var body: some View {
        Group {
            if dataSource.searchText == "" {
                if !dataSource.failedToLoadInitialData {
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            if dataSource.isLoading {
                                ForEach(0..<5) { _ in
                                    ShimmerDelegateFullListItemView()
                                }
                            } else {
                                ForEach(0..<dataSource.delegates.count, id: \.self) { index in
                                    if index == dataSource.delegates.count - 1 && dataSource.hasMore() {
                                        if !dataSource.failedToLoadMore { // try to paginate
                                            ShimmerDelegateFullListItemView()
                                                .onAppear {
                                                    dataSource.loadMore()
                                                }
                                        } else { // retry pagination
                                            RetryLoadMoreListItemView(dataSource: dataSource)
                                        }
                                    } else {
                                        if index < dataSource.delegates.count {
                                            let delegate = dataSource.delegates[index]
                                                DelegateFullListItemView(delegate: delegate)
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the delegates")
                }
            } else {
                _DelegatesSearchListView(dataSource: dataSource)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .subscriptionDidToggle)) { _ in
            // refresh if some popover sheet is presented
            if activeSheetManager.activeSheet != nil {
                dataSource.refresh()
            }
        }
    }
}

fileprivate struct _DelegatesSearchListView: View {
    @ObservedObject var dataSource: DelegatesFullListDataSource

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                if dataSource.nothingFound {
                    Text("Sorry, no delegates found")
                        .font(.body)
                        .foregroundStyle(Color.textWhite)
                        .padding(.top, 16)
                } else if dataSource.searchResultDelegates.isEmpty { // initial searching
                    ForEach(0..<7) { _ in
                        ShimmerDaoListItemView()
                    }
                } else {
                    ForEach(dataSource.searchResultDelegates) { delegate in
                        DelegateFullListItemView(delegate: delegate)
                    }
                }
            }
        }
    }
}


fileprivate struct DelegateFullListItemView: View {
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    let delegate: Delegate

    var body: some View {
        HStack {
            RoundPictureView(image: delegate.user.avatar(size: .m), imageSize: Avatar.Size.m.daoImageSize)
            
            Text(delegate.user.usernameShort)
                .font(.caption2)
                .foregroundStyle(Color.textWhite60)
            
            Spacer()
            
            if let delegated = delegate.userDelegated, delegated {
                PositiveButton("Delegated") {
                    //TODO: open delegate form to reassign permissions
                }
            } else {
                SecondaryButton("Delegate", maxWidth: 100, height: 32, font: .footnoteSemibold) {
                    //TODO: open delegate form to reassign permissions
                }
            }
        }
        .padding(12)
        .contentShape(Rectangle())
        .listRowSeparator(.hidden)
//        .onTapGesture {
//            onSelectDao?(dao)
//        }
    }
}

fileprivate struct ShimmerDelegateFullListItemView: View {
    var body: some View {
        HStack {
            ShimmerView()
                .frame(width: Avatar.Size.m.daoImageSize, height: Avatar.Size.m.daoImageSize)
                .cornerRadius(Avatar.Size.m.daoImageSize / 2)
            VStack(alignment: .leading, spacing: 4) {
                ShimmerView()
                    .frame(width: 150, height: 18)
                    .cornerRadius(9)
                ShimmerView()
                    .frame(width: 100, height: 12)
                    .cornerRadius(6)
            }

            Spacer()
            ShimmerFollowButtonView()
        }
        .padding(12)
        .listRowSeparator(.hidden)
    }
}
