//
//  SnapshotVotingResultView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-25.
//

import SwiftUI

struct SnapshotVotingResultView: View {
    let proposal: Proposal
    
    var body: some View {
        VStack {
            ForEach(proposal.choices.indices, id: \.self) { index in
                let choice = proposal.choices[index]
                let score = proposal.scores[index]
                let totalScore = proposal.scoresTotal
                switch proposal.type {
                case .basic: SnapshotSingleChoiceVotingResultBarView(choice: choice, score: score, totalScore: totalScore)
                case .singleChoice: SnapshotSingleChoiceVotingResultBarView(choice: choice, score: score, totalScore: totalScore)
                case .rankedChoice: SnapshotRankedChoiceVotingResultBarView(choice: choice, score: score, totalScore: totalScore)
                case .approval: SnapshotApprovalVotingResultBarView(choice: choice, score: score, totalScore: totalScore)
                case .weighted: SnapshotWeightedVotingResultBarView(choice: choice, score: score, totalScore: totalScore)
                case .quadratic: SnapshotWeightedVotingResultBarView(choice: choice, score: score, totalScore: totalScore)
                }
                .padding(.bottom, 30)
            }
        }
    }
}

struct ChoicesResultView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotVotingResultView(proposal: .aaveTest)
    }
}
