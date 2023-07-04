//
//  SnapshotRankedChoiceVotingView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-03.
//

import SwiftUI

struct SnapshotRankedChoiceVotingView: View {
    @State var selectedChoicesIndex: [Int] = [] {
        didSet {
            disabled = selectedChoicesIndex.count != proposal.choices.count
        }
    }
    @State var disabled: Bool = true
    let proposal: Proposal
        
    var body: some View {
        VStack {
            let choices = proposal.choices
            
            ForEach(selectedChoicesIndex, id: \.self) { index in
                SnapshotRankedChoiceVotingButtonView(choice: choices[index], isSelected: true) {
                    if let selectedIndex = selectedChoicesIndex.firstIndex(of: index) {
                        selectedChoicesIndex.remove(at: selectedIndex)
                    }
                }
            }

            if !selectedChoicesIndex.isEmpty{
                Spacer().frame(height: 20)
            }
            
            ForEach(choices.indices, id: \.self) { index in
                if !selectedChoicesIndex.contains(index) {
                    SnapshotRankedChoiceVotingButtonView(choice: choices[index], isSelected: false) {
                        selectedChoicesIndex.append(index)
                    }
                }
            }
            
            VoteButton(disabled: $disabled) {}
        }
    }
}

fileprivate struct SnapshotRankedChoiceVotingButtonView: View {
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

struct SnapshotRankedChoiceVotingView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotRankedChoiceVotingView(proposal: .aaveTest)
    }
}
