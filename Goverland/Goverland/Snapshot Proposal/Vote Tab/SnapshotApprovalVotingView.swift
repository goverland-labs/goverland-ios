//
//  SnapshotApprovalVotingView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-28.
//

import SwiftUI

struct SnapshotApprovalVotingView: View {
    @State var selectedChoicesIndex: Set<Int> = []
    let proposal: Proposal
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
            // TODO: make a separate button component
            Button(action: {
                // TODO: show dialogue
                print("submitting vote")
            }) {
                HStack {
                    Spacer()
                    Text("Vote")
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
                .foregroundColor(selectedChoicesIndex == [] ? .textWhite20 : .onPrimary)
                .background(selectedChoicesIndex == [] ? Color.disabled12 : Color.primary)
                .font(.footnoteSemibold)
                .cornerRadius(20)
            }
            .disabled(selectedChoicesIndex == [])
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

struct SnapshotApprovalVotingView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotApprovalVotingView(proposal: .aaveTest)
    }
}
