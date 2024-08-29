//
//  ProposalsSearchResultsListView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 12.07.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct ProposalsSearchResultsListView: View {
    @StateObject var dataSource: ProposalsSearchDataSource
    @Binding var path: NavigationPath
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    @State private var selectedProposalSearchIndex: Int?

    var body: some View {
        VStack(spacing: 12) {
            if dataSource.nothingFound {
                Text("Nothing found")
                    .font(.body)
                    .foregroundStyle(Color.textWhite)
                    .padding(.top, 16)
                Spacer()
            } else if dataSource.searchResultProposals.isEmpty { // initial searching
                ScrollView {
                    ForEach(0..<7) { _ in
                        ShimmerProposalListItemView()
                            .padding(.horizontal, Constants.horizontalPadding)
                    }
                }
                .padding(.top, Constants.horizontalPadding / 2)
            } else {
                List(0..<dataSource.searchResultProposals.count, id: \.self, selection: $selectedProposalSearchIndex) { index in
                    let proposal = dataSource.searchResultProposals[index]
                    ProposalListItemView(proposal: proposal) {
                        activeSheetManager.activeSheet = .daoInfoById(proposal.dao.id.uuidString)
                        Tracker.track(.searchPrpOpenDaoFromSearch)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(Constants.listInsets)
                    .listRowBackground(Color.clear)
                }
            }
        }
        .onChange(of: selectedProposalSearchIndex) { _, _ in
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
