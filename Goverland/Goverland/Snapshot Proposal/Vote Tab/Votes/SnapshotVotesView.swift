//
//  SnapshotVotesView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-06.
//

import SwiftUI

struct SnapshotVotesView: View {
    let proposal: Proposal
    @StateObject var dataSource: SnapsotVotesDataSource
    /// This view should have own active sheet manager as it is already presented in a popover
    @StateObject private var activeSheetManger = ActiveSheetManager()
    
    init(proposal: Proposal) {
        _dataSource = StateObject(wrappedValue: SnapsotVotesDataSource(proposal: proposal))
        self.proposal = proposal
    }
    
    var body: some View {
        VStack {
            let count = dataSource.votes.count
            ForEach(0..<count, id: \.self) { index in
                let vote = dataSource.votes[index]
                VoteListItemView(voter: vote.voter,
                                 votingPower: vote.votingPower,
                                 choice: proposal.choices.count > vote.choice ? proposal.choices[vote.choice] : String(vote.choice),
                                 message: vote.message)
            }
            
            Text("See all")
                .frame(width: 100, height: 30, alignment: .center)
                .background(Capsule(style: .circular)
                    .stroke(Color.secondaryContainer,style: StrokeStyle(lineWidth: 2)))
                .tint(.onSecondaryContainer)
                .font(.footnoteSemibold)
                .onTapGesture {
                    activeSheetManger.activeSheet = .proposalVoters(proposal)
                }
        }
        .sheet(item: $activeSheetManger.activeSheet) { item in
            NavigationStack {
                switch item {
                case .proposalVoters(let proposal):
                    SnapshotAllVotesView(proposal: proposal)
                default:
                    // should not happen
                    EmptyView()
                }
            }
            .accentColor(.primary)
            .overlay {
                ErrorView()
            }
        }
        .onAppear() {
            dataSource.refresh()
        }
    }
}

struct VoteListItemView: View {
    let voter: User
    let votingPower: Double
    let choice: String
    let message: String?
    var body: some View {
        Divider()
            .background(Color.secondaryContainer)
        HStack {
            IdentityView(user: voter)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.footnoteRegular)
                .foregroundColor(.textWhite)
            Text(choice)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.footnoteRegular)
                .foregroundColor(.textWhite40)
            HStack {
                Text("\(String(Utils.formattedNumber(votingPower))) Votes")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.footnoteRegular)
                    .foregroundColor(.textWhite)
                if message != nil && !message!.isEmpty {
                    Image(systemName: "text.bubble.fill")
                        .foregroundColor(.secondaryContainer)
                }
            }
        }
        .padding(.vertical, 5)
        .font(.footnoteRegular)
    }
}

struct ShimmerVoteListItemView: View {
    var body: some View {
        HStack {
            ShimmerView()
                .frame(width: 40, height: 20)
                .cornerRadius(10)
            Spacer()
            ShimmerView()
                .frame(width: 40, height: 20)
                .cornerRadius(8)
            Spacer()
            ShimmerView()
                .frame(width: 40, height: 20)
                .cornerRadius(8)
        }
    }
}

struct SnapshotVotersView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotVotesView(proposal: .aaveTest)
    }
}
