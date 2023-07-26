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
