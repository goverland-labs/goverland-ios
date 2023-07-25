//
//  SnapshotWeightedVotingResultBarView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-01.
//

import SwiftUI

struct SnapshotWeightedVotingResultBarView: View {
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
                
                ProposalVotingResultProgressBar(score: score,
                                                totalScore: totalScore,
                                                barWidth: geometry.size.width)
            }
        }
    }
}

struct SnapshotWeightedVotingResultBarView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotWeightedVotingResultBarView(choice: "", score: 10.0, totalScore: 20.0)
    }
}
