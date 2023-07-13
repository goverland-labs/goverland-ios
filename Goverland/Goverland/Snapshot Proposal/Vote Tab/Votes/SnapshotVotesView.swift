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
    
    init(proposal: Proposal) {
        _dataSource = StateObject(wrappedValue: SnapsotVotesDataSource(proposal: proposal))
        self.proposal = proposal
    }
    
    var body: some View {
        VStack {
            let count = dataSource.votes.count
            ForEach(0..<count, id: \.self) { index in
                let vote = dataSource.votes[index]
                Divider()
                    .background(Color.secondaryContainer)
                HStack {
                    IdentityView(user: vote.voter)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.footnoteRegular)
                        .foregroundColor(.textWhite)
                    Text(proposal.choices.count > vote.choice ? proposal.choices[vote.choice] : String(vote.choice))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.footnoteRegular)
                        .foregroundColor(.textWhite40)
                    HStack {
                        Text("\(String(Utils.formattedNumber(vote.votingPower))) Votes")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.footnoteRegular)
                            .foregroundColor(.textWhite)
                        if vote.message != nil && !vote.message!.isEmpty {
                            Image(systemName: "text.bubble.fill")
                                .foregroundColor(.secondaryContainer)
                        }
                    }
                }
                .padding(.vertical, 5)
                .font(.footnoteRegular)
            }
            
            Button("Load more") {
                if !dataSource.failedToLoadMore && dataSource.hasMore() {
                    dataSource.loadMore()
                }
            }
            .frame(width: 100, height: 30, alignment: .center)
            .background(Capsule(style: .circular)
                .stroke(Color.secondaryContainer,style: StrokeStyle(lineWidth: 2)))
            .tint(.onSecondaryContainer)
            .font(.footnoteSemibold)
        }
        .onAppear() {
            dataSource.refresh()
        }
    }
}

fileprivate struct ShimmerVoteListItemView: View {
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
