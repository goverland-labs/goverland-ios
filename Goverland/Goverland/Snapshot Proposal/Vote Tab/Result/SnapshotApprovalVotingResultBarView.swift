//
//  SnapshotApprovalVotingResultBarView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-28.
//

import SwiftUI

struct SnapshotApprovalVotingResultBarView: View {
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
                    Text(String(score) + " / " + String(score/totalScore * 100))
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

struct SnapshotApprovalVotingResultBarView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotApprovalVotingResultBarView(choice: "", score: 10.0, totalScore: 20.0)
    }
}
