//
//  SnapshotWeightedVotingView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-30.
//

import SwiftUI

struct SnapshotWeightedVotingView: View {
    @StateObject var viewModel: SnapshotWeightedVotinViewModel
    @State var isDisabled: Bool = true
    @State var warningViewIsPresented = false
    
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
                            isDisabled = viewModel.totalPower == 0
                        }) {
                            Image(systemName: "minus")
                                .frame(width: 40)
                                .padding(.vertical)
                        }
                        Text("\(viewModel.choicesPower[choice]!)")
                            .frame(width: 20)
                        Button(action: {
                            viewModel.increaseVotingPower(for: choice)
                            isDisabled = viewModel.totalPower == 0
                        }) {
                            Image(systemName: "plus")
                                .frame(width: 40)
                                .padding(.vertical)
                        }
                    }
                    Text(viewModel.prosentage(for: choice))
                        .frame(width: 55)
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
            
            VoteButton(disabled: $isDisabled) {
                warningViewIsPresented = true
            }
        }
        .sheet(isPresented: $warningViewIsPresented) {
            VoteWarningPopupView(warningViewIsPresented: $warningViewIsPresented)
                .presentationDetents([.medium, .large])
        }
    }
}

class SnapshotWeightedVotinViewModel: ObservableObject {
    let proposal: Proposal
    var totalPower: Int = 0
    @Published var choicesPower: [String: Int] = [:]
    
    init(proposal: Proposal) {
        self.proposal = proposal
        for choice in proposal.choices {
            self.choicesPower[choice] = 0
        }
    }
    
    func decreaseVotingPower(for choice: String) {
        if choicesPower[choice]! > 0 {
            choicesPower[choice]! -= 1
            totalPower -= 1
        }
    }
    
    func increaseVotingPower(for choice: String) {
        choicesPower[choice]! += 1
        totalPower += 1
    }
    
    func prosentage(for choice: String) -> String {
        return totalPower == 0 ? "0" : Utils.percentage(of: Double(choicesPower[choice]!), in: Double(totalPower))
    }
}


struct SnapshotWeightedVotingView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotWeightedVotingView(proposal: .aaveTest)
    }
}
