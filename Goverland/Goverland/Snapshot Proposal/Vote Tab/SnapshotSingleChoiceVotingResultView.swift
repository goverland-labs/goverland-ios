//
//  SnapshotSingleChoiceVotingResultView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-26.
//

import SwiftUI

struct SnapshotSingleChoiceVotingResultView: View {
    let proposal: Proposal
    
    var body: some View {
        ChoicesResultView(choices: proposal.choices,
                          scores: proposal.scores,
                          scoresTotal: proposal.scoresTotal)
    }
}

struct ChoicesResultView: View {
    let choices: [String]
    let scores: [Double]
    let scoresTotal: Double

    var body: some View {
        VStack {
            ForEach(choices.indices, id: \.self) { index in
                let score = scores[index]
                let totalScore = scoresTotal
                SnapshotSingleChoiceVotingResultBarView(choice: choices[index],
                                                        score: score,
                                                        totalScore: totalScore)
                .padding(.bottom, 30)
            }
        }
    }
}

fileprivate struct SnapshotSingleChoiceVotingResultBarView: View {
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


struct SnapshotSingleChoiceVotingResultView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotSingleChoiceVotingResultView(proposal: .aaveTest)
    }
}
