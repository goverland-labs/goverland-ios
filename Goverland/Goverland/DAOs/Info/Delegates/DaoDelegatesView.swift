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
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(0..<6) { _ in
                            ShimmerDelegateCardView()
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
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(dataSource.delegates) { delegate in
                            NavigationLink(destination: DelegateInfoView(delegate: delegate)) {
                                DelegateCardView(delegate: delegate)
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
