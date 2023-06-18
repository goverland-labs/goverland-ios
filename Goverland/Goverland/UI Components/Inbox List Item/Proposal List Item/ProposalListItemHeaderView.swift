//
//  ProposalListItemHeaderView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI
import SwiftDate

struct ProposalListItemHeaderView: View {
    let proposal: Proposal

    // TODO: change on backend
    var user: User {
        User(address: proposal.author, ensName: nil, image: nil)
    }
    
    var body: some View {
        HStack {
            HStack(spacing: 6) {
                IdentityView(user: user)
                DateView(date: proposal.created)
            }

            Spacer()

            // TODO: implement
            HStack(spacing: 6) {
                ReadIndicatiorView()
                ProposalStatusView(state: proposal.state)
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
        ProposalListItemHeaderView(proposal: .aaveTest)
    }
}
