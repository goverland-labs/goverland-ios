//
//  PublicUserProfileActivityView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-03-07.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct PublicUserProfileActivityView: View {
    @StateObject private var dataSource: PublicUserProfileActivityDataSource
    @Binding private var path: [PublicUserProfileScreen]

    init(address: Address, path: Binding<[PublicUserProfileScreen]>) {
        _dataSource = StateObject(wrappedValue: PublicUserProfileActivityDataSource(address: address))
        _path = path
    }

    var body: some View {
        ScrollView {
            if let daos = dataSource.votedDaos {
                _VotedDaosView(daos: daos)
            }

            _VotedProposalsView(dataSource: dataSource, path: $path)
        }
    }
}

fileprivate struct _VotedDaosView: View {
    let daos: [Dao]
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Voted in DAOs (\(daos.count))")
                    .font(.subheadlineSemibold)
                    .foregroundStyle(Color.textWhite)
                Spacer()
                if daos.count > 0 {
                    NavigationLink("See all", value: PublicUserProfileScreen.votedInDaos)
                        .font(.subheadlineSemibold)
                        .foregroundStyle(Color.primaryDim)
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, Constants.horizontalPadding * 2)

            if daos.count == 0 {
                Text("User has not voted yet")
                    .foregroundStyle(Color.textWhite)
                    .font(.bodyRegular)
                    .padding(Constants.horizontalPadding)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(daos) { dao in
                            DAORoundViewWithActiveVotes(dao: dao) {
                                activeSheetManager.activeSheet = .daoInfo(dao)
                                Tracker.track(.publicPrfVotedDaoOpen)
                            }
                        }
                    }
                    .padding(Constants.horizontalPadding)
                }
                .background(Color.containerBright)
                .cornerRadius(20)
                .padding(.horizontal, Constants.horizontalPadding)
            }
        }
    }
}

fileprivate struct _VotedProposalsView: View {
    @ObservedObject var dataSource: PublicUserProfileActivityDataSource
    @Binding var path: [PublicUserProfileScreen]
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    var votedProposals: [Proposal] {
        dataSource.votedProposals ?? []
    }

    var votesHeader: String {
        guard let votes = dataSource.total else { return "Voted in DAOs" }
        return "Votes (\(votes))"
    }

    var body: some View {
        VStack {
            HStack {
                Text(votesHeader)
                    .font(.subheadlineSemibold)
                    .foregroundStyle(Color.textWhite)
                Spacer()
                if !votedProposals.isEmpty {
                    NavigationLink("See all", value: PublicUserProfileScreen.votes(votedProposals))
                        .font(.subheadlineSemibold)
                        .foregroundStyle(Color.primaryDim)
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, Constants.horizontalPadding * 2)

            if dataSource.failedToLoadInitialData {
                RefreshIcon {
                    dataSource.refresh()
                }
            } else if dataSource.isLoading && dataSource.votedProposals == nil { // initial loading
                ForEach(0..<3) { _ in
                    ShimmerProposalListItemView()
                        .padding(.horizontal, Constants.horizontalPadding)
                }
            } else if dataSource.votedProposals?.isEmpty ?? false {
                // User has not voted yet. Message will be displayed in other component.
                Text("")
            } else {
                ForEach(votedProposals.prefix(3)) { proposal in
                    ProposalListItemNoElipsisView(proposal: proposal) {
                        Tracker.track(.publicPrfVotesOpenDao)
                        activeSheetManager.activeSheet = .daoInfo(proposal.dao)
                    }
                    .padding(.horizontal, Constants.horizontalPadding)
                    .onTapGesture {
                        Tracker.track(.publicPrfVotesOpenProposal)
                        path.append(.vote(proposal))
                    }
                }
            }
        }
        .padding(.bottom, 16)
        .onAppear {
            if votedProposals.isEmpty {
                dataSource.refresh()
            }
        }
    }
}