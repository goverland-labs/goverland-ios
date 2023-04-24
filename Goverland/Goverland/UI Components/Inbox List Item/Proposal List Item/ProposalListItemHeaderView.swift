//
//  ProposalListItemHeaderView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI
import SwiftDate

struct ProposalListItemHeaderView: View {
    let user: User
    let date: Date
    let status: VoteEventData.EventStatus
    
    var body: some View {
        HStack {
            HStack(spacing: 6) {
                IdentityView(user: user)
                DateView(date: date)
            }

            Spacer()
            
            HStack(spacing: 6) {
                ReadIndicatiorView()
                ProposalStatusView(status: status)
            }
        }
    }
}

fileprivate struct ReadIndicatiorView: View {
    var body: some View {
        Circle()
            .fill(Color.primary)
            .frame(width: 4, height: 4)
    }
}

struct ListItemHeader_Previews: PreviewProvider {
    static var previews: some View {
        ProposalListItemHeaderView(
            user: User.flipside,
            date: Date(),
            status: .activeVote
        )
    }
}
