//
//  SnapshotProposalInfoView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-27.
//

import SwiftUI

struct SnapshotProposalInfoView: View {
    let proposal: Proposal
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                Text("Strategies")
                Text("IPFS")
                Text("Voting system")
                Text("Start date")
                Text("End date")
                Text("Snapshot")
            }
            .font(.footnoteSemibold)
            .foregroundColor(.textWhite)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 15) {
                Text("strategies")
                HStack(spacing: 0) {
                    Text("#" + proposal.ipfs.prefix(7))
                    Image(systemName: "arrow.up.forward.app")
                }
                Text(proposal.type.rawValue)
                Text(proposal.votingStart.description)
                Text(proposal.votingEnd.description)
                HStack(spacing: 0) {
                    Text(proposal.snapshot)
                    Image(systemName: "arrow.up.forward.app")
                }
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
