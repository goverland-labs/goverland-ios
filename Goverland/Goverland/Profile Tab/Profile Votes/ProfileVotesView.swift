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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var votedProposals: [Proposal] {
        dataSource.votedProposals ?? []
    }
    
    var columns: [GridItem] {
        if horizontalSizeClass == .regular {
            return Array(repeating: .init(.flexible()), count: 2)
        } else {
            return Array(repeating: .init(.flexible()), count: 1)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("My votes (\(dataSource.total ?? 0))")
                    .font(.title3Semibold)
                    .foregroundStyle(Color.textWhite)
                Spacer()
                NavigationLink(value: ProfileScreen.votes) {
                    Image(systemName: "arrow.forward")
                        .font(.title3Semibold)
                        .foregroundStyle(Color.textWhite)
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, Constants.horizontalPadding * 2)
            
            if dataSource.failedToLoadInitialData {
                RefreshIcon {
                    dataSource.refresh()
                }
            } else if dataSource.isLoading && dataSource.votedProposals == nil { // initial loading
                LazyVGrid(columns: columns, spacing: 8) {
                    let count = columns.count == 1 ? 3 : 4
                    ForEach(0..<count, id: \.self) { _ in
                        ShimmerProposalListItemView()
                    }
                }
                .padding(.vertical, 4)
                .padding(.horizontal, Constants.horizontalPadding)
            } else if dataSource.votedProposals?.isEmpty ?? false {
                Text("You have not voted yet")
                    .foregroundStyle(Color.textWhite)
                    .font(.bodyRegular)
                    .padding(16)
            } else {
                LazyVGrid(columns: columns, spacing: 8) {
                    let count = columns.count == 1 ? 3 : 4
                    ForEach(votedProposals.prefix(count)) { proposal in
                        ProposalListItemView(proposal: proposal) {
                            Tracker.track(.prfVotesOpenDao)
                            activeSheetManager.activeSheet = .daoInfoById(proposal.dao.id.uuidString)
                        }
                        .onTapGesture {
                            Tracker.track(.prfVotesOpenProposal)
                            path.append(.vote(proposal))
                        }
                    }
                }
                .padding(.vertical, 4)
                .padding(.horizontal, Constants.horizontalPadding)
            }
        }
        .padding(.bottom, 16)
        .onAppear {
            if dataSource.votedProposals == nil {
                dataSource.refresh()
            }
        }
    }
}
