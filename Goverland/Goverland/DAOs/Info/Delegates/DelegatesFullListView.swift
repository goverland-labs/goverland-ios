//
//  DelegatesFullListView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 27.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

enum DelegateAction: Equatable {
    case delegate
    case add(onAdd: (Delegate) -> Void)

    static func == (lhs: DelegateAction, rhs: DelegateAction) -> Bool {
        switch (lhs, rhs) {
        case (.delegate, .delegate):
            return true
        case (.add, .add):
            return false
        default:
            return false
        }
    }
}

struct DelegatesFullListView: View {
    let action: DelegateAction

    @Environment(\.dismiss) private var dismiss
    @StateObject var dataSource: DaoDelegatesDataSource

    init(dao: Dao, action: DelegateAction) {
        self.action = action
        _dataSource = StateObject(wrappedValue: DaoDelegatesDataSource(dao: dao))
    }

    private var searchPrompt: String {
        if let total = dataSource.total {
            let totalStr = Utils.formattedNumber(Double(total))
            return "Search for \(totalStr) delegates"
        }
        return ""
    }

    private var title: String {
        switch action {
        case .delegate: return dataSource.dao.name
        case .add(_): return "Add Delegate"
        }
    }

    var body: some View {
        _DelegatesListView(action: action, dataSource: dataSource)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(title)
            .toolbar {
                if case .add(_) = action {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
            }
            .searchable(text: $dataSource.searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: searchPrompt)
            .onAppear {
                if dataSource.delegates.isEmpty {
                    dataSource.refresh()
                }
                // TODO: add tracking
            }
    }
}

fileprivate struct _DelegatesListView: View {
    let action: DelegateAction
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
                                            DelegateFullListItemView(action: action, delegate: delegate, dao: dao)
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
                _DelegatesSearchListView(action: action, dataSource: dataSource)
            }
        }
    }
}

fileprivate struct _DelegatesSearchListView: View {
    let action: DelegateAction
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
                        DelegateFullListItemView(action: action, delegate: delegate, dao: dataSource.dao)
                    }
                }
            }
        }
    }
}


fileprivate struct DelegateFullListItemView: View {
    let action: DelegateAction
    let delegate: Delegate
    let dao: Dao

    // own active sheet manager
    @StateObject private var activeSheetManager = ActiveSheetManager()
    @Environment(\.dismiss) private var dismiss


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

            switch action {
            case .delegate:
                DelegateButton(dao: dao, delegate: delegate) {
                    // TODO: track
                }
            case .add(let onAdd):
                SecondaryButton("Add", maxWidth: 100, height: 32, font: .footnoteSemibold) {
                    dismiss()
                    onAdd(delegate)
                }
            }
        }
        .padding(12)
        .contentShape(Rectangle())
        .listRowSeparator(.hidden)
        .onTapGesture {
            var newAction: DelegateAction
            switch action {
            case .delegate:
                newAction = action
            case .add(onAdd: let onAdd):
                newAction = .add { delegate in
                    // dismiss self and make a completion
                    dismiss()
                    onAdd(delegate)
                }
            }
            activeSheetManager.activeSheet = .daoDelegateProfile(dao, delegate, newAction)
        }
        .sheet(item: $activeSheetManager.activeSheet) { item in
            switch item {
            case .daoDelegateProfile(let dao, let delegate, let action):
                PopoverNavigationViewWithToast {
                    DaoDelegateProfileView(dao: dao, delegate: delegate, action: action)
                }

            default:
                EmptyView()
            }
        }
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
