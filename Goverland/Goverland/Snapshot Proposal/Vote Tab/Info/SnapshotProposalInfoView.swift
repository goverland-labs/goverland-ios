//
//  SnapshotProposalInfoView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-27.
//

import SwiftUI
import SwiftDate

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
                Text(Utils.formattedDateNoTime(proposal.votingStart))
                Text(Utils.formattedDateNoTime(proposal.votingEnd))
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
