//
//  FollowDaoListItemView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 02.06.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct DaoSharingMenu: View {
    let dao: Dao

    var body: some View {
        if let snapshotUrl = dao.snapshotUrl, let goverlandUrl = dao.goverlandUrl {
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
            ShareLink(item: dao.alias) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        }
    }
}

struct DaoListItemView: View {
    let dao: Dao
    let subscriptionMeta: SubscriptionMeta?
    let onSelectDao: ((Dao) -> Void)?
    let onFollowToggle: ((_ didFollow: Bool) -> Void)?

    private var voters: String {
        if let voters = MetricNumberFormatter().stringWithMetric(from: dao.voters) {
            return "\(voters) voters"
        }
        return ""
    }

    var body: some View {
        HStack {
            DAORoundViewWithActiveVotes(dao: dao) { onSelectDao?(dao) }
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(dao.name)
                        .font(.headlineSemibold)
                        .foregroundStyle(Color.textWhite)
                    if dao.verified {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(Color.textWhite)
                    }
                }
                Text(voters)
                    .font(.caption2)
                    .foregroundStyle(Color.textWhite60)
            }
            Spacer()
            FollowButtonView(daoID: dao.id, subscriptionID: subscriptionMeta?.id, onFollowToggle: onFollowToggle)
        }
        .padding(12)
        .contentShape(Rectangle())
        .listRowSeparator(.hidden)
        .onTapGesture {
            onSelectDao?(dao)
        }
    }
}

struct ShimmerDaoListItemView: View {
    var body: some View {
        HStack {
            ShimmerView()
                .frame(width: Avatar.Size.m.daoImageSize, height: Avatar.Size.m.daoImageSize)
                .cornerRadius(Avatar.Size.m.daoImageSize / 2)
            VStack(alignment: .leading, spacing: 4) {
                ShimmerView()
                    .frame(width: 150, height: 18)
                    .cornerRadius(9)
                ShimmerView()
                    .frame(width: 100, height: 12)
                    .cornerRadius(6)
            }

            Spacer()
            ShimmerFollowButtonView()
        }
        .padding(12)
        .listRowSeparator(.hidden)
    }
}
