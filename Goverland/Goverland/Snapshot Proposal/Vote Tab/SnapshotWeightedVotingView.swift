//
//  SnapshotWeightedVotingView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-30.
//

import SwiftUI

struct SnapshotWeightedVotingView: View {
    @StateObject var viewModel: SnapshotWeightedVotinViewModel
     
    init(proposal: Proposal) {
        _viewModel = StateObject(wrappedValue: SnapshotWeightedVotinViewModel(proposal: proposal))
    }
   
    var body: some View {
        VStack {
            ForEach(viewModel.proposal.choices, id: \.self) { choice in
                HStack(spacing: 0) {
                    Text(choice)
                        .padding()
                        .foregroundColor(.onSecondaryContainer)
                        .font(.footnoteSemibold)
                    Spacer()
                    HStack(spacing: 0) {
                        Button(action: {
                            viewModel.decreaseVotingPower(for: choice)
                        }) {
                            Image(systemName: "minus")
                                .frame(width: 40)
                                .padding(.vertical)
                        }
                        Text("\(viewModel.choicesPower[choice]!)")
                            .frame(width: 20)
                        Button(action: {
                            viewModel.increaseVotingPower(for: choice)
                        }) {
                            Image(systemName: "plus")
                                .frame(width: 40)
                                .padding(.vertical)
                        }
                    }
                    Text("\(viewModel.prosentage(for: choice))%")
                        .frame(width: 50)
                }
                .padding(.trailing)
                .foregroundColor(.onSecondaryContainer)
                .font(.footnoteSemibold)
                .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
                .background(viewModel.choicesPower[choice] != 0 ? Color.secondaryContainer : Color.clear)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.secondaryContainer, lineWidth: 1)
                )
            }
        }
    }
}

class SnapshotWeightedVotinViewModel: ObservableObject {
    let proposal: Proposal
    private var totalPower: Int = 0
    @Published var choicesPower: [String: Int] = [:]
    
    init(proposal: Proposal) {
        self.proposal = proposal
        self.totalPower = 5 //proposal.votingPower
        for choice in proposal.choices {
            self.choicesPower[choice] = 0
        }
    }
    
    func decreaseVotingPower(for choice: String) {
        if choicesPower[choice]! > 0 {
            choicesPower[choice]! -= 1
            totalPower += 1
        }
    }
    
    func increaseVotingPower(for choice: String) {
        if totalPower > 0 {
            choicesPower[choice]! += 1
            totalPower -= 1
        }
    }
    
    func prosentage(for choice: String) -> Int {
        // return choicesPower[choice] / proposal.votingPower * 100 //When API is done
        return Int(Double(choicesPower[choice]!) / 5 * 100) // for now this fix
    }
}


struct SnapshotWeightedVotingView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotWeightedVotingView(proposal: .aaveTest)
    }
}
