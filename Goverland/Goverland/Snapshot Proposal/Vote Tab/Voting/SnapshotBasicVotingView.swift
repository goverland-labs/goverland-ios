//
//  SnapshotVotingView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-04.
//

import SwiftUI


struct SnapshotBasicVotingView: View {
    let onSubmittingVote: (_ index: Int) -> ()
    static let choices = ["For", "Against", "Abstain"]

    var body: some View {
        ChoicesView(choices: Self.choices) { index in
            onSubmittingVote(index)
        }
    }
}


struct BasicVotingView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotBasicVotingView(onSubmittingVote: { _ in })
    }
}
