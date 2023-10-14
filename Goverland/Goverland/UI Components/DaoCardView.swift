//
//  DaoCardView.swift
//  Goverland
//
//  Created by Jenny Shalai on 15.06.23.
//

import SwiftUI

struct DaoCardView: View {
    let dao: Dao
    let onSelectDao: ((Dao) -> Void)?
    let onFollowToggle: ((_ didFollow: Bool) -> Void)?
    @Environment(\.presentationMode) private var presentationMode

    private var backgroundColor: Color {
        presentationMode.wrappedValue.isPresented ? .containerBright : .container
    }

    private var voters: String {
        if let voters = MetricNumberFormatter().stringWithMetric(from: dao.voters) {
            return "\(voters) voters"
        }
        return ""
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

                Text("\(voters)")
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
        Button("Load more") {
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

struct DaoCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DaoCardView(dao: .aave,
                        onSelectDao: nil,
                        onFollowToggle: nil)
            ShimmerDaoCardView()
        }
    }
}
