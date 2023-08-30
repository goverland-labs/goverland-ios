//
//  ProposalSharingMenu.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-08-29.
//

import SwiftUI

struct ProposalSharingMenu: View {
    let link: String

    var body: some View {
        if let url = Utils.urlFromString(link) {
            ShareLink(item: url) {
                Label("Share", systemImage: "square.and.arrow.up")
            }

            Button {
                UIApplication.shared.open(url)
            } label: {
                // for now we handle only Snapshot proposals
                Label("Open on Snapshot", systemImage: "arrow.up.right")
            }
        } else {
            ShareLink(item: link) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        }
    }
}

struct ProposalSharingMenu_Previews: PreviewProvider {
    static var previews: some View {
        ProposalSharingMenu(link: "")
    }
}
