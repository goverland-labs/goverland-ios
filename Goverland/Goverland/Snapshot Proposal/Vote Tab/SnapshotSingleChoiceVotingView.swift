//
//  SnapshotSingleChoiceVotingView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-26.
//

import SwiftUI

struct SnapshotSingleChoiceVotingView: View {
    @State var selectedChoiceIndex: Int?
    let proposal: Proposal
    var body: some View {
        VStack {
            let choices = proposal.choices
            ForEach(choices.indices, id: \.self) { index in
                SnapshotSingleChoiceVotingButtonView(choice: choices[index], isSelected: selectedChoiceIndex == index) {
                    if selectedChoiceIndex != index {
                        selectedChoiceIndex = index
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
                .foregroundColor(selectedChoiceIndex == nil ? .textWhite20 : .onPrimary)
                .background(selectedChoiceIndex == nil ? Color.disabled12 : Color.primary)
                .font(.footnoteSemibold)
                .cornerRadius(20)
            }
            .disabled(selectedChoiceIndex == nil)
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

struct SnapshotSingleChoiceVotingView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotSingleChoiceVotingView(proposal: .aaveTest)
    }
}
