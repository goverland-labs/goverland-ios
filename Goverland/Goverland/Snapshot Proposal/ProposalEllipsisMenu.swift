//
//  ProposalEllipsisMenu.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-08-29.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct ProposalEllipsisMenu: View {
    let proposal: Proposal
    let onRemindToVote: () -> Void

    var body: some View {
        ShareLink(item: proposal.goverlandUrl) {
            Label("Share", systemImage: "square.and.arrow.up.fill")
        }

        if let url = Utils.urlFromString(proposal.snapshotLink) {
            Button {
                Tracker.track(.snpDetailsOpenOnSnanpshot)
                UIApplication.shared.open(url)
            } label: {
                // for now we handle only Snapshot proposals
                Label("Open on Snapshot", systemImage: "arrow.up.right")
            }
        }

        Button {
            Tracker.track(.snpDetailsAddReminder)
            onRemindToVote()
        } label: {
            Label("Remind to vote", systemImage: "bell.fill")
        }
    }
}
