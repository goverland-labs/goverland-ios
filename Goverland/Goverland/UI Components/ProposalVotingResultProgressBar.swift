//
//  ProposalVotingResultProgressBar.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-25.
//

import SwiftUI

struct ProposalVotingResultProgressBar: View {
    let score: Double
    let totalScore: Double
    let barWidth: Double
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.secondaryContainer)
                .frame(height: 6, alignment: .center)
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.primary)
                .frame(width: CGFloat(score/totalScore * 100) * CGFloat(barWidth) / 100, height: 6, alignment: .center)
        }
    }
}

struct ProposalVotingResultProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProposalVotingResultProgressBar(score: 781, totalScore: 1000, barWidth: 300)
    }
}
