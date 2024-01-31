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

    var ipfs: String {
        String(proposal.ipfs.prefix(7))
    }

    var ipfsUrl: URL? {
        URL(string: "https://snapshot.4everland.link/ipfs/\(proposal.ipfs)")
    }

    var snapshot: String {
        if let _snapshot = Int(proposal.snapshot) {
            return Utils.decimalNumber(from: _snapshot)
        } else {
            return proposal.snapshot
        }
    }

    var snapshotUrl: URL? {
        if let network = Network.from(id: proposal.network) {
            return URL(string: network.blockUrlTemplate.replacingOccurrences(of: "{}", with: proposal.snapshot))
        }
        return nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            InfoLine(leading: Text("IPFS"), trailing: Text("#\(ipfs)"), url: ipfsUrl)
            InfoLine(leading: Text("Voting system"), trailing: Text(proposal.type.rawValue))
            InfoLine(leading: Text("Start date"), trailing: Text(Utils.mediumDate(proposal.votingStart)))
            InfoLine(leading: Text("End date"), trailing: Text(Utils.mediumDate(proposal.votingEnd)))
            InfoLine(leading: Text("Snapshot Block"), trailing: Text(snapshot), url: snapshotUrl)
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
