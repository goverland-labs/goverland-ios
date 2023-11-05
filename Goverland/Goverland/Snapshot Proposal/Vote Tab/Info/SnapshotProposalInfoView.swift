//
//  SnapshotProposalInfoView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-27.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct SnapshotProposalInfoView: View {
    let proposal: Proposal
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                Text("Voting system")
                Text("Start date")
                Text("End date")
            }
            .font(.footnoteSemibold)
            .foregroundColor(.textWhite)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 15) {
                Text(proposal.type.rawValue)
                Text(Utils.mediumDate(proposal.votingStart))
                Text(Utils.mediumDate(proposal.votingEnd))
            }
            .font(.footnoteSemibold)
            .foregroundColor(.textWhite)
        }
    }
}

struct SnapshotProposalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotProposalInfoView(proposal: .aaveTest)
    }
}
