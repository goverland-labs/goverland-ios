//
//  SnapshotSingleChoiceVotingView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-26.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct SnapshotSingleChoiceVotingView: View {
    let proposal: Proposal
    @Binding var voteButtonDisabled: Bool
    @Binding var choice: Int?

    var body: some View {
        ChoicesView(choices: proposal.choices, selectedChoiceIndex: $choice, voteButtonDisabled: $voteButtonDisabled)
    }
}

struct ChoicesView: View {
    let choices: [String]
    @Binding var selectedChoiceIndex: Int? {
        didSet {
            voteButtonDisabled = selectedChoiceIndex == nil
        }
    }
    @Binding var voteButtonDisabled: Bool

    var body: some View {
        VStack {
            ForEach(choices.indices, id: \.self) { index in
                SnapshotSingleChoiceVotingButtonView(choice: choices[index], isSelected: selectedChoiceIndex == index) {
                    if selectedChoiceIndex != index {
                        selectedChoiceIndex = index
                    }
                }
            }
        }
    }
}

fileprivate struct SnapshotSingleChoiceVotingButtonView: View {
    let choice: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(choice)
                    .padding()
                    .foregroundColor(.onSecondaryContainer)
                    .font(.footnoteSemibold)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
        .background(isSelected ? Color.secondaryContainer : Color.clear)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.secondaryContainer, lineWidth: 1)
        )
    }
}
