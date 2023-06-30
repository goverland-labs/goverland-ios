//
//  SnapshotBasicVotingResultView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-06.
//

import SwiftUI

struct SnapshotBasicVotingResultView: View {
    let proposal: Proposal
    
    var body: some View {
        ChoicesResultView(choices: SnapshotBasicVotingView.choices,
                          scores: proposal.scores,
                          scoresTotal: proposal.scoresTotal)
    }
}

struct SnapshotResultView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotBasicVotingResultView(proposal: .aaveTest)
    }
}
