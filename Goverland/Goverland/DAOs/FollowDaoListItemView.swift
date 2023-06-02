//
//  FollowDaoListItemView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 02.06.23.
//

import SwiftUI

struct FollowDaoListItemView: View {
    let dao: Dao

    var body: some View {
        HStack {
            RoundPictureView(image: dao.image, imageSize: 50)
            Text(dao.name)
            Spacer()
            FollowButtonView(buttonWidth: 110, buttonHeight: 35)
        }
        .padding(5)
        .listRowSeparator(.hidden)
    }
}

struct FollowDAOListItemView_Previews: PreviewProvider {
    static var previews: some View {
        FollowDaoListItemView(dao: .aave)
    }
}

