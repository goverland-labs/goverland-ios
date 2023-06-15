//
//  FollowDaoListItemView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 02.06.23.
//

import SwiftUI

struct DaoListItemView: View {
    let dao: Dao

    var body: some View {
        HStack {
            RoundPictureView(image: dao.image, imageSize: 50)
            Text(dao.name)
                .font(.headlineSemibold)
                .foregroundColor(.textWhite)
            Spacer()
            FollowButtonView(daoID: dao.id, subscriptionID: dao.subscriptionMeta?.id)
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
            ShimmerView()
                .frame(width: 110, height: 35)
                .cornerRadius(17)
        }
        .padding(5)
    }
}

struct FollowDAOListItemView_Previews: PreviewProvider {
    static var previews: some View {
        DaoListItemView(dao: .aave)
        ShimmerDaoListItemView()
    }
}

