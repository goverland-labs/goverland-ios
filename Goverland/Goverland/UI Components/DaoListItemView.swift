//
//  FollowDaoListItemView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 02.06.23.
//

import SwiftUI

struct DaoSharingMenu: View {
    let dao: Dao
    var link: String {
        "https://snapshot.org/#/\(dao.alias)"
    }

    var body: some View {
        if let url = Utils.urlFromString(link) {
            ShareLink(item: url) {
                Label("Share", systemImage: "square.and.arrow.up")
            }

            Button {
                openUrl(url)
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
            RoundPictureView(image: dao.avatar, imageSize: 50)
            VStack(alignment: .leading, spacing: 4) {
                Text(dao.name)
                    .font(.headlineRegular)
                    .foregroundColor(.textWhite)
                Text(voters)
                    .font(.caption2)
                    .foregroundColor(.textWhite60)
            }
            Spacer()
            FollowButtonView(daoID: dao.id, subscriptionID: subscriptionMeta?.id, onFollowToggle: onFollowToggle)
        }
        .padding(12)
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
                .frame(width: 50, height: 50)
                .cornerRadius(25)
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

struct DapListItemView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DaoListItemView(dao: .aave,
                            subscriptionMeta: nil,
                            onSelectDao: nil,
                            onFollowToggle: nil)
            ShimmerDaoListItemView()
        }
    }
}

