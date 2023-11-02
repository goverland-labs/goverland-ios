//
//  ProposalResultProcessBarLabelView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-27.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct ProposalResultProcessBarLabelView: View {
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
                .foregroundColor(.onSecondaryContainer)
            Spacer()
            Text(Utils.formattedNumber(score) +
                 " \(votingToken) " +
                 Utils.percentage(of: score, in: totalScore))
                .font(.footnoteSemibold)
                .foregroundColor(.textWhite)
        }
    }
}

struct ProposalResultProcessBarLabelView_Previews: PreviewProvider {
    static var previews: some View {
        ProposalResultProcessBarLabelView(choice: "", score: 0, totalScore: 0, symbol: nil)
    }
}
