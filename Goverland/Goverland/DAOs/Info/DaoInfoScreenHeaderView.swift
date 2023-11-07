//
//  DaoInfoScreenHeaderView().swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-07.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct DaoInfoScreenHeaderView: View {
    let dao: Dao
    
    var body: some View {
        HStack(spacing: 50) {
            RoundPictureView(image: dao.avatar, imageSize: 100)
            
            VStack(spacing: 20) {
                HStack {
                    InfoBadgeView(value: "\(Utils.formattedNumber(Double(dao.proposals)))", title: "Proposals")
                    InfoBadgeView(value: "\(Utils.formattedNumber(Double(dao.voters)))" , title: "Voters")
                }
                .scaledToFill()
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                
                FollowButtonView(daoID: dao.id, subscriptionID: dao.subscriptionMeta?.id) { didFollow in
                    if didFollow {
                        Tracker.track(.daoFollow)
                    }
                }
            }
        }
    }
}

fileprivate struct InfoBadgeView: View {
    let value: String
    let title: String
    var body: some View {
        VStack {
            Text(value)
                .font(.calloutSemibold)
                .foregroundColor(.textWhite)
            Text(title)
                .font(.footnoteRegular)
                .foregroundColor(.textWhite60)
        }
    }
    
}

struct DaoInfoScreenHeaderViewPreviews: PreviewProvider {
    static var previews: some View {
        DaoInfoScreenHeaderView(dao: .aave)
    }
}
