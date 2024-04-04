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

    // In the Snapshot API this is mapping like ["1": 1, "2": 3, ...], where "1" is the first element.
    @Binding var choicesPower: [String: Double]?

    @State private var totalPower: Double = 0

    init(proposal: Proposal, voteButtonDisabled: Binding<Bool>, choice: Binding<[String: Double]?>) {
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


                        Text(String(format: "%.0f", choicesPower?[String(index + 1)] ?? 0))
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
                var initialChoicesPower = [String: Double]()
                for (index, _) in proposal.choices.enumerated() {
                    initialChoicesPower[String(index + 1)] = 0
                }
                choicesPower = initialChoicesPower
            } else {
                // assure no skipped values
                for (index, _) in proposal.choices.enumerated() {
                    if choicesPower![String(index + 1)] == nil {
                        // in case not all values are passed via initial binding
                        choicesPower![String(index + 1)] = 0
                    }
                }
                updateTotal()
            }
        }
    }

    private func updateTotal() {
        var total: Double = 0
        for (index, _) in proposal.choices.enumerated() {
            total += choicesPower![String(index + 1)]!
        }
        self.totalPower = total
    }
    
    private func decreaseVotingPower(for index: Int) {
        if choicesPower![String(index + 1)]! > 0 {
            Haptic.light()
            choicesPower![String(index + 1)]! -= 1
            updateTotal()
        }
    }

    private func increaseVotingPower(for index: Int) {
        Haptic.light()
        choicesPower![String(index + 1)]! += 1
        updateTotal()
    }

    private func percentage(for index: Int) -> String {
        return totalPower == 0 ? "0" : Utils.percentage(of: Double(choicesPower![String(index + 1)]!), in: Double(totalPower))
    }
}
