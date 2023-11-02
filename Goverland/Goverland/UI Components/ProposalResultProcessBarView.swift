//
//  ProposalResultProcessBarView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-26.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct ProposalResultProcessBarView: View {
    let score: Double
    let totalScore: Double
    let width: Double
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.secondaryContainer)
                .frame(height: 6, alignment: .center)
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.primary)
                .frame(width: CGFloat(score/totalScore * 100) * CGFloat(width) / 100, height: 6, alignment: .center)
        }
    }
}

struct ProposalResultProcessBar_Previews: PreviewProvider {
    static var previews: some View {
        ProposalResultProcessBarView(score: 10, totalScore: 20, width: 50)
    }
}
