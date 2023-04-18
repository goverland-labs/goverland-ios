//
//  InboxListItemFooterMenu.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 18.04.23.
//

import SwiftUI

struct InboxListItemFooterMenu: View {
    var body: some View {
        HStack(spacing: 15) {
            // TODO: add logic to indicate following or not
            Image(systemName: "bell.slash.fill")
                .foregroundColor(.gray)
                .frame(width: 11, height: 10)

            Menu {
                Button("Share", action: performShare)
                Button("Cancel", action: performCancel)
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
                    .fontWeight(.bold)
                    .frame(width: 20, height: 20)
            }
        }
    }

    private func performShare() {}

    private func performCancel() {}
}
