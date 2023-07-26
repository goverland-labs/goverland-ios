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
                    Text(Utils.formattedNumber(score) + " | " + Utils.percentage(of: score, in: totalScore))
                        .font(.footnoteSemibold)
                        .foregroundColor(.textWhite)
                }
                
                ProposalResultProcessBar(score: score, totalScore: totalScore, width: geometry.size.width)
            }
        }
    }
}

