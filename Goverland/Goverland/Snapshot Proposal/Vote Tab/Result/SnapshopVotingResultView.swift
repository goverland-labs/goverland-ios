//
//  SnapshopVotingResultView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-26.
//

import SwiftUI

struct SnapshopVotingResultView: View {
    let proposal: Proposal
    
    var body: some View {
        VStack(spacing: 30) {
            let totalScore = proposal.scoresTotal
            let choices = proposal.choices
            let scores = proposal.scores
            
            switch proposal.type {
            case .rankedChoice:
                ForEach(choices.indices, id: \.self) { index in
                    if index < scores.count {
                        SnapshotRankedChoiceVotingResultBarView(choice: choices[index], score: scores[index], totalScore: totalScore)
                    } else {
                        SnapshotRankedChoiceVotingResultBarView(choice: choices[index], score: 0, totalScore: totalScore)
                        let _ = logError(GError.indexOutOfRange)
                    }
                }
            case .weighted:
                ForEach(choices.indices, id: \.self) { index in
                    if index < scores.count {
                        SnapshotWeightedVotingResultBarView(choice: choices[index], score: scores[index], totalScore: totalScore)
                    } else {
                        SnapshotWeightedVotingResultBarView(choice: choices[index], score: 0, totalScore: totalScore)
                        let _ = logError(GError.indexOutOfRange)
                    }
                }
            case .approval:
                ForEach(choices.indices, id: \.self) { index in
                    if index < scores.count {
                        SnapshotApprovalVotingResultBarView(choice: choices[index], score: scores[index], totalScore: totalScore)
                    } else {
                        SnapshotApprovalVotingResultBarView(choice: choices[index], score: 0, totalScore: totalScore)
                        let _ = logError(GError.indexOutOfRange)
                    }
                }
                
            case .singleChoice:
                ForEach(choices.indices, id: \.self) { index in
                    if index < scores.count {
                        SnapshotSingleChoiceVotingResultBarView(choice: choices[index], score: scores[index], totalScore: totalScore)
                    } else {
                        SnapshotSingleChoiceVotingResultBarView(choice: choices[index], score: 0, totalScore: totalScore)
                        let _ = logError(GError.indexOutOfRange)
                    }
                }
                
            case .basic:
                ForEach(choices.indices, id: \.self) { index in
                    if index < scores.count {
                        SnapshotSingleChoiceVotingResultBarView(choice: choices[index], score: scores[index], totalScore: totalScore)
                    } else {
                        SnapshotSingleChoiceVotingResultBarView(choice: choices[index], score: 0, totalScore: totalScore)
                        let _ = logError(GError.indexOutOfRange)
                    }
                }
                
            case .quadratic:
                ForEach(choices.indices, id: \.self) { index in
                    if index < scores.count {
                        SnapshotWeightedVotingResultBarView(choice: choices[index], score: scores[index], totalScore: totalScore)
                    } else {
                        SnapshotWeightedVotingResultBarView(choice: choices[index], score: 0, totalScore: totalScore)
                        let _ = logError(GError.indexOutOfRange)
                    }
                }
            }
        }
    }
}

struct SnapshopVotingResultView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshopVotingResultView(proposal: .aaveTest)
    }
}
