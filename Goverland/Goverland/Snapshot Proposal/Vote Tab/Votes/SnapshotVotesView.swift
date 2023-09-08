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
            
            let count = dataSource.votes.count
            ForEach(0..<min(5, count), id: \.self) { index in
                let vote = dataSource.votes[index]
                Divider()
                    .background(Color.secondaryContainer)
                VoteListItemView(voter: vote.voter,
                                 votingPower: vote.votingPower,
                                 choice: vote.choice,
                                 message: vote.message)
                
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
            .accentColor(.primary)
            .overlay {
                ToastView()
            }
        }
    }
}

struct VoteListItemView<ChoiceType: Decodable>: View {
    let voter: User
    let votingPower: Double
    let choice: ChoiceType
    let message: String?
    var body: some View {
        HStack {
            IdentityView(user: voter)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.footnoteRegular)
                .foregroundColor(.textWhite)

            // TODO: implement
//            Text(choice)
//                .frame(maxWidth: .infinity, alignment: .center)
//                .font(.footnoteRegular)
//                .foregroundColor(.textWhite40)

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
        SnapshotVotesView<Int>(proposal: .aaveTest)
    }
}
