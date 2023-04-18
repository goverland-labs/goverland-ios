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
    let status: InboxEventStatus
    
    var body: some View {
        HStack {
            HStack(spacing: 6) {
                IdentityView(user: user)
                DateView(date: date)
            }

            Spacer()
            
            HStack(spacing: 6) {
                ReadIndicatiorView()
                StatusView(status: status)
            }
        }
    }
}

fileprivate struct ReadIndicatiorView: View {
    var body: some View {
        Circle()
            .fill(.primary)
            .frame(width: 4, height: 4)
    }
}

struct ListItemHeader_Previews: PreviewProvider {
    static var previews: some View {
        ProposalListItemHeaderView(
            user: User(
                address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                image: URL(string: ""),
                name: "safe1.sche.eth"),
            date: Date(),
            status: .discussion
        )
    }
}
