//
//  DaoInfoScreenHeaderView().swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-07.
//

import SwiftUI

struct DaoInfoScreenHeaderView: View {
    let event: InboxEvent
    
    var body: some View {
        HStack {
            RoundPictureView(image: event.daoImage, imageSize: 100)
            HStack {
                InfoBadgeView(value: "103", title: "Proposales")
                InfoBadgeView(value: "342.9K", title: "Holders")
                InfoBadgeView(value: "$2.8B", title: "Treasury")
            }
            .scaledToFill()
            .minimumScaleFactor(0.5)
            .lineLimit(1)
        }
    }
}

fileprivate struct InfoBadgeView: View {
    let value: String
    let title: String
    var body: some View {
        VStack {
            Text(value)
                .fontWeight(.semibold)
            Text(title)
        }
    }
    
}

struct DaoInfoScreenHeaderViewPreviews: PreviewProvider {
    static var previews: some View {
        DaoInfoScreenHeaderView(event: .vote1)
    }
}