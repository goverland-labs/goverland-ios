//
//  SnapshotRankedChoiceVotingResultBarView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-03.
//

import SwiftUI

struct SnapshotRankedChoiceVotingResultBarView: View {
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
                
                ProposalVotingResultProgressBar(score: score,
                                                totalScore: totalScore,
                                                barWidth: geometry.size.width)
            }
        }
    }
}


struct SnapshotRankedChoiceVotingResultBarView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotRankedChoiceVotingResultBarView(choice: "", score: 10.0, totalScore: 20.0)
    }
}
