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
        let ipfs = String(proposal.ipfs.prefix(7))
        let ipfsUrl = URL(string: "https://snapshot.4everland.link/ipfs/\(proposal.ipfs)")
        VStack(alignment: .leading, spacing: 15) {
            InfoLine(leading: Text("IPFS"), trailing: Text("#\(ipfs)"), url: ipfsUrl)
            InfoLine(leading: Text("Voting system"), trailing: Text(proposal.type.rawValue))
            InfoLine(leading: Text("Start date"), trailing: Text(Utils.mediumDate(proposal.votingStart)))
            InfoLine(leading: Text("End date"), trailing: Text(Utils.mediumDate(proposal.votingEnd)))
        }
    }
}

fileprivate struct InfoLine: View {
    let leading: Text
    let trailing: Text
    let url: URL?

    init(leading: Text,
         trailing: Text,
         url: URL? = nil) {
        self.leading = leading
        self.trailing = trailing
        self.url = url
    }

    var body: some View {
        HStack {
            leading
                .font(.footnoteSemibold)
                .foregroundColor(.textWhite)
            Spacer()
            HStack(spacing: 4) {
                trailing
                    .font(.footnoteSemibold)
                    .foregroundColor(.textWhite)
                if url != nil {
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 12, weight: .semibold))
                }
            }
            .onTapGesture {
                if let url {
                    openUrl(url)
                }
            }
        }
    }
}
