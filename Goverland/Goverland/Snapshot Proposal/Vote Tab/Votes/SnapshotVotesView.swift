//
//  SnapshotVotesView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-06.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct SnapshotVotesView<ChoiceType: Decodable>: View {
    let proposal: Proposal
    @StateObject var dataSource: SnapsotVotesDataSource<ChoiceType>
    @State private var showAllVotes = false
    
    init(proposal: Proposal) {
        self.proposal = proposal
        _dataSource = StateObject(wrappedValue: SnapsotVotesDataSource<ChoiceType>(proposal: proposal))
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Votes \(dataSource.totalVotes)")
                    .font(.footnoteRegular)
                    .foregroundStyle(Color.textWhite)
                Spacer()
            }

            if dataSource.isLoading {
                ShimmerVoteListItemView()
            }
            
            let count = dataSource.votes.count
            ForEach(0..<min(5, count), id: \.self) { index in
                let vote = dataSource.votes[index]
                Divider()
                    .background(Color.secondaryContainer)
                VoteListItemView(proposal: proposal, vote: vote)
            }
            
            if dataSource.totalVotes >= 5 {
                Text("See all")
                    .frame(width: 100, height: 30, alignment: .center)
                    .background(Capsule(style: .circular)
                        .stroke(Color.secondaryContainer,style: StrokeStyle(lineWidth: 2)))
                    .tint(.onSecondaryContainer)
                    .font(.footnoteSemibold)
                    .onTapGesture {
                        showAllVotes = true
                    }
            }
        }        
        .onAppear() {
            dataSource.refresh()
        }
        .sheet(isPresented: $showAllVotes) {
            PopoverNavigationViewWithToast {
                SnapshotAllVotesView<ChoiceType>(proposal: proposal)
            }
        }
    }
}

struct VoteListItemView<ChoiceType: Decodable>: View {
    let proposal: Proposal
    let vote: Vote<ChoiceType>
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    @State private var showReasonAlert = false

    var body: some View {
        HStack {
            IdentityView(user: vote.voter)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.footnoteRegular)
                .foregroundStyle(Color.textWhite)
                .gesture(TapGesture().onEnded { _ in
                    activeSheetManager.activeSheet = .publicProfile(vote.voter.address)
                    Tracker.track(.snpDetailsVotesShowUserProfile)
                    
                })

            if proposal.privacy == .shutter && proposal.state == .active {
                Image(systemName: "lock.fill")
                    .foregroundStyle(Color.textWhite)
            } else {
                Text(vote.choiceStr(for: proposal) ?? "")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.footnoteRegular)
                    .foregroundStyle(Color.textWhite40)
            }

            HStack {
                Text("\(String(Utils.formattedNumber(vote.votingPower))) Votes")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.footnoteRegular)
                    .foregroundStyle(Color.textWhite)
                if let reason = vote.message, !reason.isEmpty {
                    Image(systemName: "text.bubble.fill")
                        .foregroundStyle(Color.secondaryContainer)
                }
            }
        }
        .padding(.vertical, 4)
        .font(.footnoteRegular)
        .contentShape(Rectangle())
        .onTapGesture() {
            if let reason = vote.message, !reason.isEmpty {
                showReasonAlert = true
            }
        }
        .alert(isPresented: $showReasonAlert) {
            let resaon = vote.message ?? ""
            return Alert(
                title: Text("Reason"),
                message: Text(resaon),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct ShimmerVoteListItemView: View {
    var body: some View {
        HStack {
            ShimmerView()
                .frame(width: 60, height: 20)
                .cornerRadius(10)
            Spacer()
            ShimmerView()
                .frame(width: 60, height: 20)
                .cornerRadius(8)
            Spacer()
            ShimmerView()
                .frame(width: 60, height: 20)
                .cornerRadius(8)
        }
        .padding(.vertical, 4)
    }
}
