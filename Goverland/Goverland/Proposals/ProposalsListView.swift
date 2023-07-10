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
                        ForEach(0..<5) { _ in
                            ShimmerProposalListItemView()
                                .padding(.horizontal, 12)
                        }
                    }
                    .padding(.top, 4)
                } else {
                    // TODO: pagination
                    // TODO: shimmer when loading more data
                    // TODO: open proposal detail (info)

                    List(0..<dataSource.proposals.count, id: \.self) { index in
                        let proposal = dataSource.proposals[index]
                        proposalItem(proposal: proposal)
                    }
                }
            } else {
                // searching
                if dataSource.nothingFound {
                    Text("Nothing found")
                        .font(.body)
                        .foregroundColor(.textWhite)
                        .padding(.top, 16)
                } else if dataSource.searchResultProposals.isEmpty { // initial searching
                    ForEach(0..<3) { _ in
                        ShimmerDaoListItemView()
                    }
                } else {
                    List(0..<dataSource.searchResultProposals.count, id: \.self) { index in
                        let proposal = dataSource.searchResultProposals[index]
                        proposalItem(proposal: proposal)
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .onAppear {
            Tracker.track(.searchProposalView)
            dataSource.refresh()
        }
    }

    private func proposalItem(proposal: Proposal) -> some View {
        return ProposalListItemView(proposal: proposal, isRead: true, isSelected: false)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 16, leading: 12, bottom: 16, trailing: 12))
            .listRowBackground(Color.clear)
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
