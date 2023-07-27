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
            
            if scores.count == choices.count {
                ForEach(choices.indices, id: \.self) { index in
                    GeometryReader { geometry in
                        VStack(spacing: 2) {
                            ProposalResultProcessBarLabelView(choice: choices[index],
                                                              score: scores[index],
                                                              totalScore: totalScore)
                            ProposalResultProcessBarView(score: scores[index],
                                                         totalScore: totalScore,
                                                         width: geometry.size.width)
                        }
                    }
                }
            } else {
                let _ = logError(GError.voteResultsInconsistency(id: proposal.id))
                EmptyView()
            }
        }
    }
}

struct SnapshopVotingResultView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshopVotingResultView(proposal: .aaveTest)
    }
}
