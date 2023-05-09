//
//  InboxDetailHeader.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-18.
//

import SwiftUI

struct InboxDetailHeaderView: View {
    let event: InboxEvent
    
    var body: some View {
        HStack(spacing: 12) {
            RoundPictureView(image: event.daoImage, imageSize: 50)
            Text("Deplay Uniswap V3 on StarkNet")
                .fontWeight(.semibold)
            Spacer()
        }
    }
}

struct InboxDetailHeader_Previews: PreviewProvider {
    static var previews: some View {
        InboxDetailHeaderView(event: InboxEvent.vote1)
    }
}
