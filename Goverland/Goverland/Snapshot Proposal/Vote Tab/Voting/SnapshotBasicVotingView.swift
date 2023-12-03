//
//  SnapshotVotingView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-04.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI


struct SnapshotBasicVotingView: View {
    @Binding var voteButtonDisabled: Bool
    @Binding var choice: Int?
    static let choices = ["For", "Against", "Abstain"]

    var body: some View {
        ChoicesView(choices: Self.choices, selectedChoiceIndex: $choice, voteButtonDisabled: $voteButtonDisabled)
    }
}
