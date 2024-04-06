//
//  ProposalSharingMenu.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-08-29.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct ProposalSharingMenu: View {
    let link: String
    let isRead: Bool?
    let markCompletion: (() -> Void)?
    let isArchived: Bool?
    let archivationCompletion: (() -> Void)?

    init(link: String, 
         isRead: Bool? = nil,
         markCompletion: (() -> Void)? = nil,
         isArchived: Bool? = nil,
         archivationCompletion: (() -> Void)? = nil) {
        self.link = link
        self.isRead = isRead
        self.markCompletion = markCompletion
        self.isArchived = isArchived
        self.archivationCompletion = archivationCompletion
    }

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

        if let isRead {
            if isRead {
                Button {
                    markCompletion?()
                } label: {
                    Label("Mark as unread", systemImage: "envelope.fill")
                }
            } else {
                Button {
                    markCompletion?()
                } label: {
                    Label("Mark as read", systemImage: "envelope.open.fill")
                }
            }
        }

        if let isArchived {
            if isArchived {
                Button {
                    archivationCompletion?()
                } label: {
                    Label("Unarchive", systemImage: "trash.slash.fill")
                }
            } else {
                Button {
                    archivationCompletion?()
                } label: {
                    Label("Archive", systemImage: "trash.fill")
                }
            }
        }
    }
}
