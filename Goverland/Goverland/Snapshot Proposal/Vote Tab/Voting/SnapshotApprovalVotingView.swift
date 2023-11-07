//
//  SnapshotApprovalVotingView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-28.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct SnapshotApprovalVotingView: View {
    @State var selectedChoicesIndex: Set<Int> = [] {
        didSet {
            voteButtonDisabled = selectedChoicesIndex == []
        }
    }

    let proposal: Proposal
    @Binding var voteButtonDisabled: Bool

    var body: some View {
        VStack {
            let choices = proposal.choices
            ForEach(choices.indices, id: \.self) { index in
                SnapshotApprovalVotingButtonView(choice: choices[index], isSelected: selectedChoicesIndex.contains(index)) {
                    if selectedChoicesIndex.contains(index) {
                        selectedChoicesIndex.remove(index)
                    } else {
                        selectedChoicesIndex.insert(index)
                    }
                }
            }
        }
    }
}

fileprivate struct SnapshotApprovalVotingButtonView: View {
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
