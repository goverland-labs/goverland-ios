//
//  SnapshotVotingView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-04.
//

import SwiftUI

struct SnapshotVotingView: View {
    @State var selectedChoiceIndex: Int?
    private let choices = ["For", "Against", "Abstain"]
    
    var body: some View {
        VStack {
            ForEach(0..<choices.count, id: \.self) { index in
                SnapshotVotingButtonView(choice: self.choices[index], isChosen: self.selectedChoiceIndex == index) {
                    if self.selectedChoiceIndex != index {
                        self.selectedChoiceIndex = index
                    }
                }
            }
            
            Button(action: {
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

struct BasicVotingView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotVotingView()
    }
}
