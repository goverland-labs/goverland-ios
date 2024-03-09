//
//  PublicProfileActivityView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-03-07.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct PublicProfileActivityView: View {
    let dataSource: PublicProfileDataSource
    
    var body: some View {
        VotesInDaosView(data: dataSource)
        VotesListView(data: dataSource)
    }
}

fileprivate struct VotesInDaosView: View {
    let data: PublicProfileDataSource
    var body: some View {
        if data.failedToLoadInitialData {
            RefreshIcon {
                data.refresh()
            }
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    if data.profile?.daos == nil { // initial loading
                        ForEach(0..<3) { _ in
                            ShimmerView()
                                .frame(width: Avatar.Size.m.daoImageSize, height: Avatar.Size.m.daoImageSize)
                                .cornerRadius(Avatar.Size.m.daoImageSize / 2)
                        }
                    } else {
                        ForEach(data.profile!.daos) { dao in
                            RoundPictureView(image: dao.avatar(size: .m), imageSize: Avatar.Size.m.daoImageSize)
                        }
                    }
                }
                .background(Color.container)
                .cornerRadius(20)
                .padding(.horizontal, 8)
            }
        }
    }
}

fileprivate struct VotesListView: View {
    let data: PublicProfileDataSource
    var body: some View {
        VStack {
            HStack {
                Text("My votes (\(data.total ?? 0))")
                    .font(.subheadlineSemibold)
                    .foregroundStyle(Color.textWhite)
                Spacer()
                NavigationLink("See all", value: ProfileScreen.votes)
                    .font(.subheadlineSemibold)
                    .foregroundStyle(Color.primaryDim)
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)

            if data.failedToLoadInitialData {
                RefreshIcon {
                    data.getVotes()
                }
            } else if data.isLoading && data.votes == nil {
                ForEach(0..<3) { _ in
                    ShimmerProposalListItemCondensedView()
                        .padding(.horizontal, 8)
                }
            } else if data.votes?.isEmpty ?? false {
                Text("You have not voted yet")
                    .foregroundStyle(Color.textWhite)
                    .font(.bodyRegular)
                    .padding(16)
            } else {
                ForEach(data.votes.prefix(3)) { proposal in
                    ProposalListItemCondensedView(proposal: proposal) {
                        Tracker.track(.prfVotesOpenDao)
                        activeSheetManager.activeSheet = .daoInfo(proposal.dao)
                    }
                    .padding(.horizontal, 8)
                    .onTapGesture {
                        Tracker.track(.prfVotesOpenProposal)
                        path.append(.vote(proposal))
                    }
                }
            }
        }
        .padding(.bottom, 16)
        .onAppear {
            if votes.isEmpty {
                data.getVotes()
            }
        }
    }
}
