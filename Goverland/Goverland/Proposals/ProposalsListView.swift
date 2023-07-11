//
//  SearchProposalView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-07.
//

import SwiftUI

struct ProposalsListView: View {
    @StateObject var dataSource: ProposalDataSource
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(spacing: 0) {
            if dataSource.searchText == "" {
                if dataSource.isLoading && dataSource.proposals.count == 0 {
                    ScrollView {
                        ForEach(0..<3) { _ in
                            ShimmerProposalListItemView()
                                .padding(.horizontal, 12)
                        }
                    }
                    .padding(.top, 4)
                } else {
                    List(0..<dataSource.proposals.count, id: \.self) { index in
                        if index == dataSource.proposals.count - 1 && dataSource.hasMore() {
                            ZStack {
                                if !dataSource.failedToLoadMore { // try to paginate
                                    // TODO: minor: padding a bit higher than it should me
                                    ShimmerProposalListItemView()
                                        .onAppear {
                                            dataSource.loadMore()
                                        }
                                } else { // retry pagination
                                    RetryLoadMoreListItemView(dataSource: dataSource)
                                }
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 0, trailing: 12))
                            .listRowBackground(Color.clear)
                        } else {
                            let proposal = dataSource.proposals[index]
                            proposalItem(proposal: proposal)
                        }
                    }
                }
            } else {
                // searching
                VStack(spacing: 12) {

                    if dataSource.nothingFound {
                        Text("Nothing found")
                            .font(.body)
                            .foregroundColor(.textWhite)
                            .padding(.top, 16)
                    } else if dataSource.searchResultProposals.isEmpty { // initial searching
                        ScrollView {
                            ForEach(0..<3) { _ in
                                ShimmerProposalListItemView()
                                    .padding(.horizontal, 12)
                            }
                        }
                        .padding(.top, 4)
                    } else {
                        List(0..<dataSource.searchResultProposals.count, id: \.self) { index in
                            let proposal = dataSource.searchResultProposals[index]
                            proposalItem(proposal: proposal)
                        }
                    }

                }
            }
        }
        .onAppear {
            if dataSource.searchText == "" {
                Tracker.track(.screenSearchPrp)
                dataSource.refresh()
            } else {
                // This view is used by parent when searching by text
                // do nothing
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
    
    private func proposalItem(proposal: Proposal) -> some View {
        return ProposalListItemView(proposal: proposal, isRead: true, isSelected: false)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 16, leading: 12, bottom: 16, trailing: 12))
            .listRowBackground(Color.clear)
        // TODO: will not work for ellipsis
            .onTapGesture {
                path.append(proposal)
            }
    }
}

struct SearchProposalView_Previews: PreviewProvider {
    static var previews: some View {
        ProposalsListView(dataSource: ProposalDataSource(), path: .constant(NavigationPath()))
    }
}
