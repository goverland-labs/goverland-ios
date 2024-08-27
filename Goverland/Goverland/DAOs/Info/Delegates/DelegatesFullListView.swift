//
//  DelegatesFullListView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 27.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

struct DelegatesFullListView: View {
    @StateObject var dataSource: DaoDelegatesDataSource

    private var searchPrompt: String {
        if let total = dataSource.total {
            let totalStr = Utils.formattedNumber(Double(total))
            return "Search for \(totalStr) delegates"
        }
        return ""
    }

    init(dao: Dao) {
        _dataSource = StateObject(wrappedValue: DaoDelegatesDataSource(dao: dao))
    }
    
    var body: some View {
        _DelegatesListView(dataSource: dataSource)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(dataSource.dao.name)
            .searchable(text: $dataSource.searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: searchPrompt)
            .onAppear {
                if dataSource.delegates.isEmpty {
                    dataSource.refresh()
                }
            }
    }
}

fileprivate struct _DelegatesListView: View {
    @ObservedObject var dataSource: DaoDelegatesDataSource
    
    var dao: Dao {
        return dataSource.dao
    }

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
                                            DelegateFullListItemView(delegate: delegate, dao: dao)
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
    }
}

fileprivate struct _DelegatesSearchListView: View {
    @ObservedObject var dataSource: DaoDelegatesDataSource

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
                        ShimmerDelegateFullListItemView()
                    }
                } else {
                    ForEach(dataSource.searchResultDelegates) { delegate in
                        DelegateFullListItemView(delegate: delegate, dao: dataSource.dao)
                    }
                }
            }
        }
    }
}


fileprivate struct DelegateFullListItemView: View {
    let delegate: Delegate
    let dao: Dao

    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    var body: some View {
        HStack(spacing: Constants.horizontalPadding) {
            RoundPictureView(image: delegate.user.avatar(size: .m), imageSize: Avatar.Size.m.daoImageSize)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(delegate.user.usernameShort)
                    .foregroundStyle(Color.textWhite)
                    .font(.bodySemibold)
                    .lineLimit(1)

                if delegate.user.resolvedName != nil {
                    Text(delegate.user.address.short)
                        .foregroundStyle(Color.textWhite60)
                        .font(.footnoteRegular)
                        .lineLimit(1)
                }
                
                // TODO: "Delegated: 50% of your VP"
                // show delegated power if applicable
            }
            
            Spacer()
            
            DelegateButton(isDelegated: delegate.delegationInfo.percentDelegated != 0) {
                activeSheetManager.activeSheet = .daoUserDelegate(dao, delegate.user)
            }
            
        }
        .padding(12)
        .contentShape(Rectangle())
        .listRowSeparator(.hidden)
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
