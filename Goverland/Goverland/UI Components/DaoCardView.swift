//
//  DaoCardView.swift
//  Goverland
//
//  Created by Jenny Shalai on 15.06.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct DaoCardView: View {
    let dao: Dao
    let subheader: String
    let onSelectDao: ((Dao) -> Void)?
    let onFollowToggle: ((_ didFollow: Bool) -> Void)?
    @Environment(\.presentationMode) private var presentationMode

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
        presentationMode.wrappedValue.isPresented ? .containerBright : .container
    }

    var body: some View {
        VStack {
            RoundPictureView(image: dao.avatar, imageSize: 90)
                .padding(.top, 18)
                .onTapGesture {
                    onSelectDao?(dao)
                }
            
            VStack(spacing: 3) {
                Text(dao.name)
                    .font(.headlineSemibold)
                    .foregroundColor(.textWhite)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)

                Text("\(subheader)")
                    .font(.сaption2Regular)
                    .foregroundColor(.textWhite60)
            }
            .padding(.horizontal, 12)

            Spacer()
            FollowButtonView(daoID: dao.id, subscriptionID: dao.subscriptionMeta?.id, onFollowToggle: onFollowToggle)
                // we change ID here becase SwiftUI not alway correctly update this component
                // when following/unfollowing from other views
                .id("\(dao.id)-\(dao.subscriptionMeta == nil)")
                .padding(.bottom, 18)
        }
        .frame(width: 162, height: 215)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor))
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
                .frame(width: 90, height: 90)
                .cornerRadius(45)
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
