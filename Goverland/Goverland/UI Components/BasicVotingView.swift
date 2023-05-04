//
//  BasicVotingView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-04.
//

import SwiftUI

struct BasicVotingView: View {
    @State private var isChosed: Bool = false
    var body: some View {
        VStack {
            BasicVotingButtonView(choice: "For")
            BasicVotingButtonView(choice: "Against")
            BasicVotingButtonView(choice: "Abstain")
        }
    }
}

struct BasicVotingView_Previews: PreviewProvider {
    static var previews: some View {
        BasicVotingView()
    }
}
