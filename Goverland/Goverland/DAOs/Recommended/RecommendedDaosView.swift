//
//  RecommendedDaosView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct RecommendedDaosView: View {
    let daos: [Dao]
    let onDismiss: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                Button {
                    dismiss()
                    onDismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.textWhite40)
                        .font(.system(size: 26))
                }
            }

            Text("Recommended DAOs")
                .font(.title3Semibold)
                .foregroundStyle(Color.textWhite)

            Text("Based on the tokens in your wallet, we recommend following these DAOs")
                .font(.subheadlineRegular)
                .foregroundStyle(Color.textWhite)

            List(daos) { dao in
                DaoCardWideView(dao: dao, onSelectDao: nil, onFollowToggle: nil)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                    .listRowBackground(Color.clear)
            }
            .padding(.top, 8)
        }
        .padding(.top, 16)
        .padding(.bottom, 0)
        .padding(.horizontal, 12)
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    RecommendedDaosView(daos: [.aave, .gnosis], onDismiss: {})
}
