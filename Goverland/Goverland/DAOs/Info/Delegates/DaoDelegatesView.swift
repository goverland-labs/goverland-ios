//
//  DaoDelegatesView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 11.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DaoDelegatesView: View {
    @StateObject private var dataSource: DaoDelegatesDataSource
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    init(dao: Dao) {
        let dataSource = DaoDelegatesDataSource(dao: dao)
        _dataSource = StateObject(wrappedValue: dataSource)
    }

    var columns: [GridItem] {
        if horizontalSizeClass == .regular {
            return Array(repeating: .init(.flexible()), count: 2)
        } else {
            return Array(repeating: .init(.flexible()), count: 1)
        }
    }

    var body: some View {
        Group {
            if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the delegates")
            } else if dataSource.isLoading {
                // loading in progress
                _ShimmerDelegatesListHeaderView()
                    .padding(.horizontal, Constants.horizontalPadding * 2)
                    .padding(.top, Constants.horizontalPadding)
                    .padding(.bottom, Constants.horizontalPadding / 2)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(0..<6) { _ in
                            ShimmerDelegateListItemView()
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, Constants.horizontalPadding)
                }
            } else if dataSource.delegates.isEmpty {
                VStack {
                    Text("No delegates found")
                        .foregroundStyle(Color.textWhite)
                        .padding()
                    Spacer()
                }
            } else {
                _DelegatesListHeaderView(count: dataSource.total!)
                    .padding(.horizontal, Constants.horizontalPadding * 2)
                    .padding(.top, Constants.horizontalPadding)
                    .padding(.bottom, Constants.horizontalPadding / 2)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(dataSource.delegates) { delegate in
                            NavigationLink(destination: DelegateInfoView(delegate: delegate)) {
                                DelegateListItemView(delegate: delegate)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, Constants.horizontalPadding)
                }
                .refreshable {
                    dataSource.refresh()
                }
            }
        }
        .scrollIndicators(.hidden)
        .onAppear() {
            // TODO: track
//            Tracker.track(.screenDelegates)
            if dataSource.delegates.isEmpty {
                dataSource.refresh()
            }
        }
    }
}

fileprivate struct _DelegatesListHeaderView: View {
    let count: Int

    var formattedCount: String {
        Utils.formattedNumber(Double(count))
    }

    var body: some View {
        HStack {
            Text("Delegates (\(formattedCount))")
                .font(.subheadlineSemibold)
                .foregroundStyle(Color.textWhite)
            Spacer()
            NavigationLink(destination: DelegatesFullListView()) {
                Text("See all")
                    .font(.subheadlineSemibold)
                    .foregroundStyle(Color.primaryDim)
            }
        }
    }
}

fileprivate struct _ShimmerDelegatesListHeaderView: View {
    var body: some View {
        HStack {
            ShimmerView.rounded(width: 110, height: 26)
            Spacer()
            ShimmerView.rounded(width: 60, height: 26)
        }
    }
}
