//
//  ProposalEllipsisMenu.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-08-29.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct ProposalEllipsisMenu: View {
    let link: String

    var body: some View {
        if let url = Utils.urlFromString(link) {
            ShareLink(item: url) {
                Label("Share", systemImage: "square.and.arrow.up.fill")
            }

            Button {
                UIApplication.shared.open(url)
            } label: {
                // for now we handle only Snapshot proposals
                Label("Open on Snapshot", systemImage: "arrow.up.right")
            }
        } else {
            ShareLink(item: link) {
                Label("Share", systemImage: "square.and.arrow.up.fill")
            }
        }
    }
}
