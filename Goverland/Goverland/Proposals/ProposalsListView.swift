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

    @State private var selectedProposalIndex: Int?
    @State private var selectedProposalSearchIndex: Int?
    
    var body: some View {
        Group {
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
                    List(0..<dataSource.proposals.count, id: \.self, selection: $selectedProposalIndex) { index in
                        if index == dataSource.proposals.count - 1 && dataSource.hasMore() {
                            ZStack {
                                if !dataSource.failedToLoadMore { // try to paginate
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
                        List(0..<dataSource.searchResultProposals.count, id: \.self, selection: $selectedProposalSearchIndex) { index in
                            let proposal = dataSource.searchResultProposals[index]
                            proposalItem(proposal: proposal)
                        }
                    }
                }
            }
        }
        .onChange(of: selectedProposalIndex) { _ in
            if let index = selectedProposalIndex, dataSource.proposals.count > index {
                path.append(dataSource.proposals[index])
            }
        }
        .onChange(of: selectedProposalSearchIndex) { _ in
            if let index = selectedProposalSearchIndex, dataSource.searchResultProposals.count > index {
                path.append(dataSource.searchResultProposals[index])
            }
        }
        .onAppear {
            if dataSource.searchText == "" {
                selectedProposalIndex = nil
                Tracker.track(.screenSearchPrp)
                if dataSource.proposals.isEmpty {
                    dataSource.refresh()
                }
            } else {
                // This view is used by parent when searching by text
                selectedProposalSearchIndex = nil
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
    
    private func proposalItem(proposal: Proposal) -> some View {
        return ProposalListItemView(proposal: proposal, isSelected: false, isRead: false, displayUnreadIndicator: false) {
            ProposalSharingMenu(link: proposal.link)
        }
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 16, leading: 12, bottom: 16, trailing: 12))
        .listRowBackground(Color.clear)
    }
}

struct SearchProposalView_Previews: PreviewProvider {
    static var previews: some View {
        ProposalsListView(dataSource: ProposalDataSource(), path: .constant(NavigationPath()))
    }
}
