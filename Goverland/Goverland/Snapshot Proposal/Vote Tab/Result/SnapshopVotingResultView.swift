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
            
            ForEach(choices.indices, id: \.self) { index in
                GeometryReader { geometry in
                    VStack(spacing: 2) {
                        ProposalResultProcessBarLabelView(
                            choice: choices[index],
                            score: scores.count != choices.count ? 0 : scores[index],
                            totalScore: scores.count != choices.count ? 100 : totalScore)
                        ProposalResultProcessBarView(
                            score: scores.count != choices.count ? 0 : scores[index],
                            totalScore: scores.count != choices.count ? 100 : totalScore,
                            width: geometry.size.width)
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
