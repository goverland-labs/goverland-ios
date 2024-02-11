//
//  SnapshopVotingResultView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-26.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct SnapshopVotingResultView: View {
    let proposal: Proposal
    
    var body: some View {
        VStack(spacing: 30) {
            let totalScore = proposal.scoresTotal
            let choices = proposal.choices
            let scores = proposal.scores
            let symbol = proposal.symbol
            
            ForEach(choices.indices, id: \.self) { index in
                GeometryReader { geometry in
                    VStack(spacing: 2) {
                        ProposalResultProcessBarLabelView(
                            choice: choices[index],
                            score: scores.count != choices.count ? 0 : scores[index],
                            totalScore: scores.count != choices.count ? 100 : totalScore,
                            symbol: symbol)
                        ProposalResultProcessBarView(
                            score: scores.count != choices.count ? 0 : scores[index],
                            totalScore: scores.count != choices.count ? 100 : totalScore,
                            width: geometry.size.width)
                    }
                }
            }

            if proposal.quorum > 0 {
                GeometryReader { geometry in
                    VStack(spacing: 2) {
                        HStack {
                            Text("Quorum")
                                .font(.footnoteSemibold)
                                .foregroundStyle(Color.onSecondaryContainer)
                            Spacer()
                            Text(Utils.percentage(of: proposal.quorum, in: 100))
                                .font(.footnoteSemibold)
                                .foregroundStyle(Color.textWhite)
                        }

                        ProposalResultProcessBarView(
                            score: Double(proposal.quorum < 100 ? proposal.quorum : 100),
                            totalScore: 100,
                            width: geometry.size.width)
                    }
                }
            }
        }
    }
}
