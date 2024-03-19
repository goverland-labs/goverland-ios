//
//  DaoCardView.swift
//  Goverland
//
//  Created by Jenny Shalai on 15.06.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct DaoCardView: View {
    @State var dao: Dao
    let subheader: String
    let onSelectDao: ((Dao) -> Void)?
    let onFollowToggle: ((_ didFollow: Bool) -> Void)?
    @Environment(\.isPresented) private var isPresented

    init(dao: Dao,
         subheader: String? = nil,
         onSelectDao: ((Dao) -> Void)?,
         onFollowToggle: ((_ didFollow: Bool) -> Void)?)
    {
        self.dao = dao
        if let subheader {
            self.subheader = subheader
        } else {
            if let voters = MetricNumberFormatter().stringWithMetric(from: dao.voters) {
                self.subheader = "\(voters) voters"
            } else {
                self.subheader = ""
            }
        }
        self.onSelectDao = onSelectDao
        self.onFollowToggle = onFollowToggle
    }

    private var backgroundColor: Color {
        isPresented ? .containerBright : .container
    }

    var body: some View {
        VStack {
            RoundPictureView(image: dao.avatar(size: .xl), imageSize: Avatar.Size.xl.daoImageSize)
                .padding(.top, 18)
                .onTapGesture {
                    onSelectDao?(dao)
                }
            
            VStack(spacing: 3) {
                HStack(spacing: 4) {
                    Text(dao.name)
                        .font(.headlineSemibold)
                        .foregroundStyle(Color.textWhite)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)

                    if dao.verified {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(Color.textWhite)
                    }
                }

                Text("\(subheader)")
                    .font(.сaption2Regular)
                    .foregroundStyle(Color.textWhite60)
            }
            .padding(.horizontal, 12)

            Spacer()
            FollowButtonView(daoID: dao.id, subscriptionID: dao.subscriptionMeta?.id, onFollowToggle: onFollowToggle)
                // we change ID here becase SwiftUI not alway correctly update this component
                // when following/unfollowing from other views
                .id(dao.hashValue)
                .padding(.bottom, 18)
        }
        .frame(width: 162, height: 215)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor))
        .onReceive(NotificationCenter.default.publisher(for: .subscriptionDidToggle)) { notification in
            if let (daoId, subscriptionMeta) = notification.object as? (UUID, SubscriptionMeta?) {
                if dao.id == daoId {
                    dao = dao.withSubscriptionMeta(subscriptionMeta)
                }
            }
        }
    }
}

struct RetryLoadMoreCardView: View {
    let dataSource: GroupedDaosDataSource
    let category: DaoCategory

    var body: some View {
        RefreshIcon {
            dataSource.retryLoadMore(category: category)
        }
        .frame(width: 130)
    }
}

struct ShimmerDaoCardView: View {
    var body: some View {
        VStack {
            ShimmerView()
                .frame(width: Avatar.Size.xl.daoImageSize, height: Avatar.Size.xl.daoImageSize)
                .cornerRadius(Avatar.Size.xl.daoImageSize / 2)
                .padding(.top, 17)

            VStack(spacing: 3) {
                ShimmerView()
                    .frame(width: 60, height: 20)
                    .cornerRadius(10)
                ShimmerView()
                    .frame(width: 80, height: 16)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 12)

            Spacer()
            ShimmerFollowButtonView()
                .padding(.bottom, 20)
        }
        .frame(width: 162, height: 215)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.container))
    }
}
