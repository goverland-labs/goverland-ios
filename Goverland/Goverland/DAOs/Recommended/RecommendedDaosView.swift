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

    @StateObject private var activeSheetManager = ActiveSheetManager()
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
                DaoCardWideView(
                    dao: dao,
                    onSelectDao: { dao in
                        activeSheetManager.activeSheet = .daoInfo(dao)
                        Tracker.track(.daosRecommendationOpenDao)
                    },
                    onFollowToggle: { didFollow, _ in
                        if didFollow {
                            Tracker.track(.daosRecommendationFollow)
                        }
                    })
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
        .sheet(item: $activeSheetManager.activeSheet) { item in
            switch item {
            case .daoInfo(let dao):
                PopoverNavigationViewWithToast {
                    DaoInfoView(dao: dao)
                }
            default:
                // should not happen
                EmptyView()
            }
        }
        .onAppear {
            Tracker.track(.screenDaosRecommendation)
        }
    }
}

#Preview {
    RecommendedDaosView(daos: [.aave, .gnosis], onDismiss: {})
}
