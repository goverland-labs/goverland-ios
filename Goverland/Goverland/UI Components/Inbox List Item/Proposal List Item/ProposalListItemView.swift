//
//  ProposalListItemView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-28.
//

import SwiftUI

struct ProposalListItemView: View {
    @State private var isRead = false
    let proposal: Proposal

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.container)
            
            VStack(spacing: 15) {
                ProposalListItemHeaderView(proposal: proposal)
                ProposalListItemBodyView(proposal: proposal)
                ProposalListItemFooterView(proposal: proposal)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
        }
    }
}

struct InboxListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ProposalListItemView(proposal: .aaveTest)
    }
}
