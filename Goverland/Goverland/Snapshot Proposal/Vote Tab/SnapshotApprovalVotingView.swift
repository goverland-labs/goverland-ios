//
//  SnapshotApprovalVotingView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-28.
//

import SwiftUI

struct SnapshotApprovalVotingView: View {
    @State var selectedChoicesIndex: Set<Int> = [] {
        didSet {
            disabled = selectedChoicesIndex == []
        }
    }
    @State var disabled: Bool = true
    @State var warningViewIsPresented = false

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

            VoteButton(disabled: $disabled) {
                warningViewIsPresented = true
            }
        }
        .sheet(isPresented: $warningViewIsPresented) {
            VoteWarningPopupView(warningViewIsPresented: $warningViewIsPresented)
                .presentationDetents([.medium, .large])
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
