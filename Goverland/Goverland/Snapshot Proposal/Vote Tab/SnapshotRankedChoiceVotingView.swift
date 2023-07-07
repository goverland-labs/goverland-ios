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
            
            ForEach(selectedChoicesIndex, id: \.self) { choice in
                if let index = selectedChoicesIndex.firstIndex(of: choice) {
                    SnapshotRankedChoiceVotingButtonView(choice: choices[choice],
                                                         choiceIndex: index + 1,
                                                         isSelected: true) {
                        selectedChoicesIndex.remove(at: index)
                    }
                }
            }

            if !selectedChoicesIndex.isEmpty{
                Spacer().frame(height: 20)
            }
            
            ForEach(choices.indices, id: \.self) { choice in
                if !selectedChoicesIndex.contains(choice) {
                    SnapshotRankedChoiceVotingButtonView(choice: choices[choice], choiceIndex: nil, isSelected: false) {
                        selectedChoicesIndex.append(choice)
                    }
                }
            }
            
            VoteButton(disabled: $disabled) {}
        }
    }
}

fileprivate struct SnapshotRankedChoiceVotingButtonView: View {
    let choice: String
    let choiceIndex: Int?
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack  {
                HStack {
                    Text(choiceIndex != nil ? "(\(choiceIndex!))" : "")
                        .padding(.leading)
                        .foregroundColor(.onSecondaryContainer)
                        .font(.footnoteSemibold)
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Text(choice)
                        .padding()
                        .foregroundColor(.onSecondaryContainer)
                        .font(.footnoteSemibold)
                    Spacer()
                }
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
