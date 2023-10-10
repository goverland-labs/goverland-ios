//
//  SnapshotVotesView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-06.
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
                    .foregroundColor(.textWhite)
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
            NavigationStack {
                SnapshotAllVotesView<ChoiceType>(proposal: proposal)
            }
            .accentColor(.textWhite)
            .overlay {
                ToastView()
            }
        }
    }
}

struct VoteListItemView<ChoiceType: Decodable>: View {
    let proposal: Proposal
    let vote: Vote<ChoiceType>

    var choice: String? {
        switch proposal.type {
        case .basic, .singleChoice:
            if let choice = vote.choice as? Int, choice <= proposal.choices.count {
                return String(proposal.choices[choice - 1])
            }
        case .approval, .rankedChoice:
            if let choice = vote.choice as? [Int] {
                return choice.map { String($0) }.joined(separator: ", ")
            }
        case .weighted, .quadratic:
            if let choice = vote.choice as? [String: Int] {
                let total = choice.values.reduce(0, +)
                return choice.map { "\(Utils.percentage(of: Double($0.value), in: Double(total))) for \($0.key)" }.joined(separator: ", ")
            }
        }

        if proposal.privacy == .shutter {
            // result is encrepted. fallback case
            if let choice = vote.choice as? String {
                return choice
            }
        }

        logError(GError.failedVotesDecoding(proposalID: proposal.id))
        return nil
    }


    var body: some View {
        HStack {
            IdentityView(user: vote.voter)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.footnoteRegular)
                .foregroundColor(.textWhite)

            if proposal.privacy == .shutter && proposal.state == .active {
                Image(systemName: "lock.fill")
                    .foregroundColor(.textWhite)
            } else {
                Text(choice ?? "")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.footnoteRegular)
                    .foregroundColor(.textWhite40)
            }

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
        .padding(.vertical, 4)
        .font(.footnoteRegular)
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

struct SnapshotVotersView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotVotesView<Int>(proposal: .aaveTest)
    }
}
