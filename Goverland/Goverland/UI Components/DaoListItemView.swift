//
//  FollowDaoListItemView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 02.06.23.
//

import SwiftUI

struct DaoListItemView: View {
    let dao: Dao
    let subscriptionMeta: SubscriptionMeta?
    let onFollowToggle: ((_ didFollow: Bool) -> Void)?

    private var members: String {
        if let members = MetricNumberFormatter().stringWithMetric(from: dao.members) {
            return "\(members) members"
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
                Text(members)
                    .font(.caption2)
                    .foregroundColor(.textWhite60)
            }
            Spacer()
            FollowButtonView(daoID: dao.id, subscriptionID: subscriptionMeta?.id, onFollowToggle: onFollowToggle)
        }
        .padding(12)
        .listRowSeparator(.hidden)
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
            DaoListItemView(dao: .aave, subscriptionMeta: nil, onFollowToggle: nil)
            ShimmerDaoListItemView()
        }
    }
}

