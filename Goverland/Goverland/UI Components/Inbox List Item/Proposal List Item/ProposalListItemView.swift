//
//  ProposalListItemView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-28.
//

import SwiftUI

struct ProposalListItemView: View {
    @State private var isRead = false
    let event: InboxEvent

    var data: VoteEventData {
        event.data as! VoteEventData
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.container)
            
            VStack(spacing: 15) {
                ProposalListItemHeaderView(user: data.user, date: event.date, status: data.status)
                ProposalListItemBodyView(data: data, daoImage: event.daoImage)
                ProposalListItemFooterView(meta: data.meta)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
        }
    }
}

struct InboxListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ProposalListItemView(event: InboxEvent.vote1)
    }
}
