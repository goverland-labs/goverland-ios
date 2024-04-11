//
//  PublicUserProfileActivityView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-03-07.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct PublicUserProfileActivityView: View {
    @StateObject private var votesDataSource: PublicUserProfileVotesDataSource
    @StateObject private var daosDataSource: PublicUserProfileDaosDataSource
    @Binding private var path: [PublicUserProfileScreen]

    init(user: User, path: Binding<[PublicUserProfileScreen]>) {
        _votesDataSource = StateObject(wrappedValue: PublicUserProfileVotesDataSource(user: user))
        _daosDataSource = StateObject(wrappedValue: PublicUserProfileDaosDataSource(address: user.address))
        _path = path
    }

    var body: some View {
        ScrollView {
            _VotedDaosView(dataSource: daosDataSource)
            _VotedProposalsView(dataSource: votesDataSource, path: $path)
        }
    }
}

fileprivate struct _VotedDaosView: View {
    @ObservedObject var dataSource: PublicUserProfileDaosDataSource
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    var daos: [Dao] {
        dataSource.daos
    }

    var header: String {
        dataSource.isLoading || dataSource.failedToLoadInitialData ?
            "Voted in DAOs" :
            "Voted in DAOs (\(daos.count))"
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(header)
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

            if dataSource.failedToLoadInitialData {
                RefreshIcon {
                    dataSource.refresh()
                }
            } else if daos.count == 0 && !dataSource.isLoading {
                Text("User has not voted yet")
                    .foregroundStyle(Color.textWhite)
                    .font(.bodyRegular)
                    .padding(Constants.horizontalPadding)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        if dataSource.isLoading { // initial loading
                            ForEach(0..<5) { _ in
                                ShimmerView()
                                    .frame(width: Avatar.Size.m.daoImageSize, height: Avatar.Size.m.daoImageSize)
                                    .cornerRadius(Avatar.Size.m.daoImageSize / 2)
                            }
                        } else {
                            ForEach(daos) { dao in
                                DAORoundViewWithActiveVotes(dao: dao) {
                                    activeSheetManager.activeSheet = .daoInfo(dao)
                                    Tracker.track(.publicPrfVotedDaoOpen)
                                }
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
    @ObservedObject var dataSource: PublicUserProfileVotesDataSource
    @Binding var path: [PublicUserProfileScreen]
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    var votedProposals: [Proposal] {
        dataSource.votedProposals
    }

    var header: String {
        guard let votes = dataSource.total else { return "Votes" }
        return "Votes (\(votes))"
    }

    var body: some View {
        VStack {
            HStack {
                Text(header)
                    .font(.subheadlineSemibold)
                    .foregroundStyle(Color.textWhite)
                Spacer()
                if !votedProposals.isEmpty {
                    NavigationLink("See all", value: PublicUserProfileScreen.votes)
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
            } else if dataSource.isLoading { // initial loading
                ForEach(0..<3) { _ in
                    ShimmerProposalListItemView()
                        .padding(.horizontal, Constants.horizontalPadding)
                }
            } else if dataSource.votedProposals.isEmpty {
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
