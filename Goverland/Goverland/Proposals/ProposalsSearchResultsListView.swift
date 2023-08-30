//
//  ProposalsSearchResultsListView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 12.07.23.
//

import SwiftUI

struct ProposalsSearchResultsListView: View {
    @StateObject var dataSource: ProposalsSearchResultsDataSource
    @Binding var path: NavigationPath
    @EnvironmentObject private var activeSheetManger: ActiveSheetManager

    @State private var selectedProposalSearchIndex: Int?

    var body: some View {
        VStack(spacing: 12) {
            if dataSource.nothingFound {
                Text("Nothing found")
                    .font(.body)
                    .foregroundColor(.textWhite)
                    .padding(.top, 16)
                Spacer()
            } else if dataSource.searchResultProposals.isEmpty { // initial searching
                ScrollView {
                    ForEach(0..<3) { _ in
                        ShimmerProposalListItemCondensedView()
                            .padding(.horizontal, 12)
                    }
                }
                .padding(.top, 4)
            } else {
                List(0..<dataSource.searchResultProposals.count, id: \.self, selection: $selectedProposalSearchIndex) { index in
                    let proposal = dataSource.searchResultProposals[index]
                    ProposalListItemCondensedView(proposal: proposal,
                                                  onDaoTap: {
                        activeSheetManger.activeSheet = .daoInfo(proposal.dao)
                        Tracker.track(.searchPrpOpenDaoFromSearch)
                    }) {
                        ProposalSharingMenu(link: proposal.link)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 16, leading: 12, bottom: 16, trailing: 12))
                    .listRowBackground(Color.clear)
                }
            }
        }
        .onChange(of: selectedProposalSearchIndex) { _ in
            if let index = selectedProposalSearchIndex, dataSource.searchResultProposals.count > index {
                path.append(dataSource.searchResultProposals[index])
                Tracker.track(.searchPrpOpenFromSearch)
            }
        }
        .onAppear {
            selectedProposalSearchIndex = nil
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}
