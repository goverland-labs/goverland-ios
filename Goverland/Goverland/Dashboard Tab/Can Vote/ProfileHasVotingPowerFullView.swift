//
//  ProfileHasVotingPowerFullView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 25.01.24.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

struct ProfileHasVotingPowerFullView: View {
    @StateObject var dataSource = ProfileHasVotingPowerDataSource.dashboard
    @Binding var path: NavigationPath
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    @State private var selectedProposalIndex: Int?

    var body: some View {
        Group {
            if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the proposals list")
            } else if dataSource.isLoading && dataSource.proposals == nil {
                ScrollView {
                    ForEach(0..<7) { _ in
                        ShimmerProposalListItemView()
                            .padding(.horizontal, Constants.horizontalPadding)
                    }
                }
                .padding(.top, Constants.horizontalPadding / 2)
            } else {
                if let count = dataSource.proposals?.count, count > 0 {
                    List(0..<count, id: \.self, selection: $selectedProposalIndex) { index in
                        let proposal = dataSource.proposals![index]
                        ProposalListItemView(proposal: proposal) {
                            activeSheetManager.activeSheet = .daoInfoById(proposal.dao.id.uuidString)
                            Tracker.track(.dashCanVoteOpenDaoFromList)
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(Constants.listInsets)
                        .listRowBackground(Color.clear)
                    }
                } else {
                    Text("No recommended proposals found.")
                }
            }
        }
        .onChange(of: selectedProposalIndex) { _, _ in
            if let index = selectedProposalIndex, (dataSource.proposals?.count ?? 0) > index {
                path.append(dataSource.proposals![index])
                Tracker.track(.dashCanVoteOpenPrpFromList)
            }
        }
        .onAppear {
            selectedProposalIndex = nil
            Tracker.track(.screenDashCanVote)
            if dataSource.proposals?.isEmpty ?? true {
                dataSource.refresh()
            }
        }
        .navigationTitle("You have voting power")
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}
