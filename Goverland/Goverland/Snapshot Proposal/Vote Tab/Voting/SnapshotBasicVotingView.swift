//
//  SnapshotVotingView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-04.
//

import SwiftUI


struct SnapshotBasicVotingView: View {
    @Binding var voteButtonDisabled: Bool
    static let choices = ["For", "Against", "Abstain"]

    var body: some View {
        ChoicesView(choices: Self.choices, voteButtonDisabled: $voteButtonDisabled)
    }
}
