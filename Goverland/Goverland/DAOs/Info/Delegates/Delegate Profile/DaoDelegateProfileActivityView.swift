//
//  DaoDelegateProfileActivityView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-07-24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DaoDelegateProfileActivityView: View {
    let delegated: Bool
    @StateObject private var dataSource: DaoDelegateProfileActivityDataSource

    @State private var selectedProposalIndex: Int?
    @State private var path = NavigationPath()

    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    init(daoId: String, delegateId: String, delegated: Bool) {
        self.delegated = delegated
        let dataSource = DaoDelegateProfileActivityDataSource(daoId: daoId, delegateId: delegateId)
        _dataSource = StateObject(wrappedValue: dataSource)
    }

    var proposals: [Proposal] {
        dataSource.proposals ?? []
    }

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if dataSource.failedToLoadInitialData {
                    RefreshIcon {
                        dataSource.refresh()
                    }
                    Spacer()
                } else if dataSource.isLoading && dataSource.proposals == nil {
                    ScrollView {
                        ForEach(0..<7) { _ in
                            ShimmerProposalListItemView()
                                .padding(.horizontal, Constants.horizontalPadding)
                        }
                    }
                    .padding(.top, Constants.horizontalPadding / 2)
                } else if dataSource.proposals != nil && proposals.isEmpty {
                    Text("No votes")
                        .font(.body)
                        .foregroundStyle(Color.textWhite)
                        .padding(.top, 16)
                    Spacer()
                } else {
                    List(0..<proposals.count, id: \.self, selection: $selectedProposalIndex) { index in
                        let proposal = proposals[index]
                        if index == proposals.count - 1 && dataSource.hasMore() {
                            ZStack {
                                if !dataSource.failedToLoadMore {
                                    ShimmerProposalListItemView()
                                        .onAppear {
                                            dataSource.loadMore()
                                        }
                                } else {
                                    RetryLoadMoreListItemView(dataSource: dataSource)
                                }
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(Constants.listInsets)
                            .listRowBackground(Color.clear)
                        } else {
                            ProposalListItemView(proposal: proposal, isDelegateVoted: delegated) {
                                Tracker.track(.delegateProfileOpenDao, parameters: ["dao" : proposal.dao.name])
                                activeSheetManager.activeSheet = .daoInfoById(proposal.dao.id.uuidString)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(Constants.listInsets)
                            .listRowBackground(Color.clear)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .onChange(of: selectedProposalIndex) { _, _ in
                if let index = selectedProposalIndex, proposals.count > index {
                    let proposal = proposals[index]
                    path.append(proposal)
                }
                selectedProposalIndex = nil
            }
            .navigationDestination(for: Proposal.self) { proposal in
                SnapshotProposalView(proposal: proposal)
                    .onAppear {
                        Tracker.track(.delegateProfileOpenProposal, parameters: ["proposalId" : "\(proposal.id)"])
                    }
                    .environmentObject(activeSheetManager)
            }
        }
        .onAppear() {
            if proposals.isEmpty {
                dataSource.refresh()
            }
        }
    }
}
