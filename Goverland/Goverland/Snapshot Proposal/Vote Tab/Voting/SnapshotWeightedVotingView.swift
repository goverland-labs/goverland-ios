//
//  SnapshotWeightedVotingView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-30.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct SnapshotWeightedVotingView: View {
    let proposal: Proposal
    @Binding var voteButtonDisabled: Bool

    // In Snapshot API this is mapping like ["1": 1, "2": 3, ...], where "1" is the first element.
    @Binding var choicesPower: [String: Int]?
    
    @State private var totalPower: Int = 0

    init(proposal: Proposal, voteButtonDisabled: Binding<Bool>, choice: Binding<[String: Int]?>) {
        self.proposal = proposal
        _voteButtonDisabled = voteButtonDisabled
        _choicesPower = choice
    }

    var body: some View {
        VStack {
            ForEach(Array(zip(proposal.choices.indices, proposal.choices)), id: \.0) { index, choice in
                HStack(spacing: 0) {
                    Text(choice)
                        .padding()
                        .foregroundStyle(Color.onSecondaryContainer)
                        .font(.footnoteSemibold)

                    Spacer()

                    HStack(spacing: 0) {
                        Button(action: {
                            decreaseVotingPower(for: index)
                            voteButtonDisabled = totalPower == 0
                        }) {
                            Image(systemName: "minus")
                                .frame(width: 40)
                                .padding(.vertical)
                        }

                        Text("\(choicesPower?[String(index + 1)] ?? 0)")
                            .frame(width: 20)

                        Button(action: {
                            increaseVotingPower(for: index)
                            voteButtonDisabled = totalPower == 0
                        }) {
                            Image(systemName: "plus")
                                .frame(width: 40)
                                .padding(.vertical)
                        }
                    }

                    Text(percentage(for: index))
                        .frame(width: 55)
                }
                .padding(.trailing)
                .foregroundStyle(Color.onSecondaryContainer)
                .font(.footnoteSemibold)
                .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
                .background((choicesPower?[String(index + 1)] ?? 0) != 0 ? Color.secondaryContainer : Color.clear)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.secondaryContainer, lineWidth: 1)
                )
            }
        }
        .onAppear {
            // if trying to do the same in the init, it doesn't work 🤷‍♂️
            if choicesPower == nil {
                var initialChoicesPower = [String: Int]()
                for (index, _) in proposal.choices.enumerated() {
                    initialChoicesPower[String(index + 1)] = 0
                }
                choicesPower = initialChoicesPower
            }
        }
    }

    private func decreaseVotingPower(for index: Int) {
        if choicesPower![String(index + 1)]! > 0 {
            choicesPower![String(index + 1)]! -= 1
            totalPower -= 1
        }
    }

    private func increaseVotingPower(for index: Int) {
        choicesPower![String(index + 1)]! += 1
        totalPower += 1
    }

    private func percentage(for index: Int) -> String {
        return totalPower == 0 ? "0" : Utils.percentage(of: Double(choicesPower![String(index + 1)]!), in: Double(totalPower))
    }
}
