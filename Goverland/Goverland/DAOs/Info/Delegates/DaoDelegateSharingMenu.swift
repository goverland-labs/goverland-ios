//
//  DaoDelegateSharingMenu.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 27.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DaoDelegateSharingMenu: View {
    // TODO: implement properly
    var body: some View {
        if let url = Utils.urlFromString("https://goverland.xyz") {
            ShareLink(item: url) {
                Label("Share", systemImage: "square.and.arrow.up.fill")
            }

            Button {
                UIApplication.shared.open(url)
            } label: {
                Label("Open on Snapshot", systemImage: "arrow.up.right")
            }
        }
    }
}
