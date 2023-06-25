//
//  SnapshotVotingView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-04.
//

import SwiftUI


struct SnapshotBasicVotingView: View {
    @State var selectedChoiceIndex: Int?

    enum ChoiceType: Int, Identifiable {
        var id: Int { self.rawValue }

        case `for` = 0
        case against
        case abstain

        static var allChoices: [ChoiceType] {
            return [.for, .against, .abstain]
        }

        var localizedName: String {
            switch self {
            case .for:
                return "For"
            case .against:
                return "Against"
            case .abstain:
                return "Abstain"
            }
        }
    }
    
    var body: some View {
        VStack {
            ForEach(ChoiceType.allChoices) { choice in
                SnapshotBasicVotingButtonView(choice: choice, isSelected: selectedChoiceIndex == choice.rawValue) {
                    if selectedChoiceIndex != choice.rawValue {
                        selectedChoiceIndex = choice.rawValue
                    }
                }
            }
            
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

struct SnapshotBasicVotingButtonView: View {
    let choice: SnapshotBasicVotingView.ChoiceType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(choice.localizedName)
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

struct BasicVotingView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotBasicVotingView()
    }
}
