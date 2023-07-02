//
//  SnapshotWeightedVotingResultView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-01.
//

import SwiftUI

struct SnapshotWeightedVotingResultView: View {
    let proposal: Proposal
    
    var body: some View {
        VStack {
            let choices = proposal.choices
            ForEach(choices.indices, id: \.self) { index in
                let score = proposal.scores[index]
                let totalScore = proposal.scoresTotal
                SnapshotWeightedVotingResultBarView(choice: choices[index],
                                                    score: score,
                                                    totalScore: totalScore)
                .padding(.bottom, 30)
            }
        }
    }
}

fileprivate struct SnapshotWeightedVotingResultBarView: View {
    let choice: String
    let score: Double
    let totalScore: Double
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 2) {
                HStack {
                    Text(choice)
                        .font(.footnoteSemibold)
                        .foregroundColor(.onSecondaryContainer)
                    Spacer()
                    // TODO: converter to present rounded number with "K" needed here
                    // TODO: converter for %
                    Text(Utils.formattedNumber(score) + " | " + Utils.percentage(of: score, in: totalScore))
                        .font(.footnoteSemibold)
                        .foregroundColor(.textWhite)
                }
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.secondaryContainer)
                        .frame(height: 6, alignment: .center)
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.primary)
                        .frame(width: CGFloat(score/totalScore * 100) * CGFloat(geometry.size.width) / 100, height: 6, alignment: .center)
                }
            }
        }
    }
}

struct SnapshotWeightedVotingResultView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotWeightedVotingResultView(proposal: .aaveTest)
    }
}
