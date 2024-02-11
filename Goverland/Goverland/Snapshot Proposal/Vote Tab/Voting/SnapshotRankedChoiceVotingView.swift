//
//  SnapshotRankedChoiceVotingView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-03.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct SnapshotRankedChoiceVotingView: View {
    let proposal: Proposal
    @Binding var voteButtonDisabled: Bool
    @Binding var choice: [Int]? {
        didSet {
            voteButtonDisabled = choice == nil || (choice!.count != proposal.choices.count)
        }
    }

    var body: some View {
        VStack {
            let choices = proposal.choices
            
            if choice != nil {
                ForEach(choice!, id: \.self) { element in
                    if let index = choice!.firstIndex(of: element) {
                        SnapshotRankedChoiceVotingButtonView(choice: choices[element],
                                                             choiceIndex: index + 1,
                                                             isSelected: true) {
                            choice!.remove(at: index)
                        }
                    }
                }
            }

            if !(choice?.isEmpty ?? true) {
                Spacer().frame(height: 20)
            }
            
            ForEach(choices.indices, id: \.self) { index in
                if !(choice?.contains(index) ?? false) {
                    SnapshotRankedChoiceVotingButtonView(choice: choices[index], choiceIndex: nil, isSelected: false) {
                        if choice == nil {
                            choice = []
                        }
                        choice!.append(index)
                    }
                }
            }
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
                        .foregroundStyle(Color.onSecondaryContainer)
                        .font(.footnoteSemibold)
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Text(choice)
                        .padding()
                        .foregroundStyle(Color.onSecondaryContainer)
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
