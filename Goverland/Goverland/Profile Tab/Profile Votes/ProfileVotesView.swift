//
//  ProfileVotesView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 05.02.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct ProfileVotesView: View {
    @Binding var path: [ProfileScreen]
    @StateObject private var dataSource = ProfileVotesDataSource.shared
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    var votedProposals: [Proposal] {
        dataSource.votedProposals ?? []
    }

    var body: some View {
        VStack {
            HStack {
                Text("My votes (\(dataSource.total ?? 0))")
                    .font(.subheadlineSemibold)
                    .foregroundColor(.textWhite)
                Spacer()
                NavigationLink("See all", value: ProfileScreen.votes)
                    .font(.subheadlineSemibold)
                    .foregroundColor(.primaryDim)
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)

            if dataSource.failedToLoadInitialData {
                RefreshIcon {
                    dataSource.refresh()
                }
            } else if dataSource.isLoading && dataSource.votedProposals == nil { // initial loading
                ForEach(0..<3) { _ in
                    ShimmerProposalListItemCondensedView()
                        .padding(.horizontal, 8)
                }
            } else if dataSource.votedProposals?.isEmpty ?? false {
                Text("You have not voted yet")
                    .foregroundStyle(Color.textWhite)
                    .font(.bodyRegular)
                    .padding(16)
            } else {
                ForEach(votedProposals.prefix(3)) { proposal in
                    ProposalListItemCondensedView(proposal: proposal) {
                        // TODO: track
                        activeSheetManager.activeSheet = .daoInfo(proposal.dao)
                    }
                    .padding(.horizontal, 8)
                    .onTapGesture {
                        // TODO: track
                        path.append(ProfileScreen.vote(proposal))
                    }
                }
            }
        }
        .onAppear {
            if votedProposals.isEmpty {
                dataSource.refresh()
            }
        }
    }
}


//List(0..<votedProposals.count, id: \.self, selection: $selectedProposalIndex) { index in
//    if index == votedProposals.count - 1 && dataSource.hasMore() { // pagination
//        ZStack {
//            if !dataSource.failedToLoadMore { // try to paginate
//                ShimmerProposalListItemView()
//                    .onAppear {
//                        dataSource.loadMore()
//                    }
//            } else { // retry pagination
//                RetryLoadMoreListItemView(dataSource: dataSource)
//            }
//        }
//        .listRowSeparator(.hidden)
//        .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
//        .listRowBackground(Color.clear)
//    } else {
//        let proposal = votedProposals[index]
//        ProposalListItemView(proposal: proposal,
//                             isSelected: false,
//                             isRead: false) {
//            activeSheetManager.activeSheet = .daoInfo(proposal.dao)
//            //                            Tracker.track(openDaoFromListItemTrackingEvent)
//        } menuContent: {
//            ProposalSharingMenu(link: proposal.link, isRead: nil, markCompletion: nil)
//        }
//        .listRowSeparator(.hidden)
//        .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
//        .listRowBackground(Color.clear)
//    }
//}
