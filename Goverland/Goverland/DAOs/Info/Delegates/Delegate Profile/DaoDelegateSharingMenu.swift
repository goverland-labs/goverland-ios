//
//  DaoDelegateSharingMenu.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 27.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DaoDelegateSharingMenu: View {
    let daoDelegate: DaoDelegate
    
    var body: some View {
        if let snapshotUrl = daoDelegate.snapshotUrl, let goverlandUrl = daoDelegate.goverlandUrl {
            ShareLink(item: goverlandUrl) {
                Label("Share", systemImage: "square.and.arrow.up")
            }

            Button {
                openUrl(snapshotUrl)
            } label: {
                // for now we handle only Snapshot proposals
                Label("Open on Snapshot", systemImage: "arrow.up.right")
            }
        } else {
            ShareLink(item: daoDelegate.dao.alias) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        }
    }
}