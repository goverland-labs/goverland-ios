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

    // TODO: remove NavigationLink here
    var body: some View {
        HStack {
            NavigationLink(value: dao) {
                RoundPictureView(image: dao.image, imageSize: 50)
                Text(dao.name)
                    .font(.headlineSemibold)
                    .foregroundColor(.textWhite)
                Spacer()
                FollowButtonView(daoID: dao.id, subscriptionID: subscriptionMeta?.id)
            }
        }
        .navigationDestination(for: Dao.self) { dao in
            DaoInfoView(daoID: dao.id)
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
            ShimmerView()
                .frame(width: 150, height: 26)
                .cornerRadius(13)
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
            DaoListItemView(dao: .aave, subscriptionMeta: nil)
            ShimmerDaoListItemView()
        }
    }
}

