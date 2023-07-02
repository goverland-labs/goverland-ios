//
//  SearchProposalView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-07.
//

import SwiftUI

struct SearchProposalView: View {
    var body: some View {
        VStack {
            Text("TODO: Suggested Proposals")
            Spacer()
        }
        .onAppear { Tracker.track(.searchProposalView) }
    }
}

struct SearchProposalView_Previews: PreviewProvider {
    static var previews: some View {
        SearchProposalView()
    }
}
