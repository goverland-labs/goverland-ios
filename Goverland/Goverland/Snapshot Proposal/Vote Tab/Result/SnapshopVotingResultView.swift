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
                        _ProcessBarLabelView(
                            choice: choices[index],
                            score: scores.count != choices.count ? 0 : scores[index],
                            totalScore: scores.count != choices.count ? 100 : totalScore,
                            symbol: symbol)
                        ProcessBarView(
                            score: scores.count != choices.count ? 0 : scores[index],
                            totalScore: scores.count != choices.count ? 100 : totalScore,
                            height: 6)
                    }
                }
            }

            if proposal.quorum > 0 {
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

                    ProcessBarView(
                        score: Double(proposal.quorum < 100 ? proposal.quorum : 100),
                        totalScore: 100,
                        height: 6)
                }
            }
        }
    }
}

fileprivate struct _ProcessBarLabelView: View {
    let choice: String
    let score: Double
    let totalScore: Double
    let symbol: String?

    private var votingToken: String {
        return symbol ?? "|"
    }

    var body: some View {
        HStack {
            Text(choice)
                .font(.footnoteSemibold)
                .foregroundStyle(Color.onSecondaryContainer)
            Spacer()
            Text(Utils.formattedNumber(score) +
                 " \(votingToken) " +
                 Utils.percentage(of: score, in: totalScore))
                .font(.footnoteSemibold)
                .foregroundStyle(Color.textWhite)
        }
    }
}

