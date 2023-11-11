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
    @Binding var choicesPower: [String: Int]?
    @State private var totalPower: Int = 0

    init(proposal: Proposal, voteButtonDisabled: Binding<Bool>, choice: Binding<[String: Int]?>) {
        self.proposal = proposal
        _voteButtonDisabled = voteButtonDisabled
        _choicesPower = choice
    }

    var body: some View {
        VStack {
            ForEach(proposal.choices, id: \.self) { choice in
                HStack(spacing: 0) {
                    Text(choice)
                        .padding()
                        .foregroundColor(.onSecondaryContainer)
                        .font(.footnoteSemibold)

                    Spacer()

                    HStack(spacing: 0) {
                        Button(action: {
                            decreaseVotingPower(for: choice)
                            voteButtonDisabled = totalPower == 0
                        }) {
                            Image(systemName: "minus")
                                .frame(width: 40)
                                .padding(.vertical)
                        }

                        Text("\(choicesPower?[choice] ?? 0)")
                            .frame(width: 20)

                        Button(action: {
                            increaseVotingPower(for: choice)
                            voteButtonDisabled = totalPower == 0
                        }) {
                            Image(systemName: "plus")
                                .frame(width: 40)
                                .padding(.vertical)
                        }
                    }

                    Text(percentage(for: choice))
                        .frame(width: 55)
                }
                .padding(.trailing)
                .foregroundColor(.onSecondaryContainer)
                .font(.footnoteSemibold)
                .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
                .background((choicesPower?[choice] ?? 0) != 0 ? Color.secondaryContainer : Color.clear)
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
                for choice in proposal.choices {
                    initialChoicesPower[choice] = 0
                }
                choicesPower = initialChoicesPower
            }
        }
    }

    private func decreaseVotingPower(for choice: String) {
        if choicesPower![choice]! > 0 {
            choicesPower![choice]! -= 1
            totalPower -= 1
        }
    }

    private func increaseVotingPower(for choice: String) {
        choicesPower![choice]! += 1
        totalPower += 1
    }

    private func percentage(for choice: String) -> String {
        return totalPower == 0 ? "0" : Utils.percentage(of: Double(choicesPower![choice]!), in: Double(totalPower))
    }
}
