//
//  AllDaoVotersListView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-02-20.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct AllDaoVotersListView: View {
    @StateObject private var dataSource: AllDaoVotersDataSource
    @Environment(\.dismiss) private var dismiss
    
    init(dao: Dao, filteringOption: DatesFiltetingOption) {
        _dataSource = StateObject(wrappedValue: AllDaoVotersDataSource(dao: dao, filteringOption: filteringOption))
    }
    
    var body: some View {
        Group {
            if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the voters list")
            } else {
                if dataSource.isLoading {
                    List(0..<5, id: \.self) { _ in
                        ShimmerVoteListItemView()
                            .padding([.top, .bottom])
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets())
                    }
                } else {
                    List(0..<dataSource.voters.count, id: \.self) { index in
                        if index == dataSource.voters.count - 1 && dataSource.hasMore() {
                            if !dataSource.failedToLoadMore {
                                ShimmerTopVoteListItemView()
                                    .padding([.top, .bottom])
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets())
                                    .onAppear {
                                        dataSource.loadMore()
                                    }
                            } else {
                                RetryLoadMoreListItemView(dataSource: dataSource)
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets())
                            }
                        } else {
                            let voter = dataSource.voters[index]
                            TopVoteListItemView(voter)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }
        .onAppear() {
            dataSource.refresh()
            Tracker.track(.screenDaoInsightsTopVoters)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("\(dataSource.dao.name) voters by aVP (\(dataSource.filteringOption.localizedName))")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.textWhite)
                }
            }
        }
    }
}

fileprivate struct TopVoteListItemView: View {
    let voter: TopDaoVoter
    
    init(_ voter: TopDaoVoter) {
        self.voter = voter
    }
    
    var body: some View {
        HStack {
            IdentityView(user: voter.voter) {
                // TODO
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text("\(Utils.formattedNumber(voter.votesCount)) times")
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.footnoteRegular)
                .foregroundColor(.textWhite40)

            Text("\(Utils.formattedNumber(voter.votingPower)) aVP")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.footnoteRegular)
                .foregroundColor(.textWhite)
        }
        .padding(.vertical)
    }
}

fileprivate struct ShimmerTopVoteListItemView: View {
    var body: some View {
        HStack {
            ShimmerView()
                .frame(width: 60, height: 20)
                .cornerRadius(10)
            Spacer()
            ShimmerView()
                .frame(width: 60, height: 20)
                .cornerRadius(8)
            Spacer()
            ShimmerView()
                .frame(width: 60, height: 20)
                .cornerRadius(8)
        }
        .padding(.vertical, 4)
    }
}

