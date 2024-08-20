//
//  DaoDelegateProfileActivityView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-07-24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DaoDelegateProfileActivityView: View {
    let proposals: [Proposal]
    
    init(proposals: [Proposal]) {
        self.proposals = proposals
    }
    
    var body: some View {
        List(0..<proposals.count, id: \.self) { i in
            ProposalListItemView(proposal: proposals[i], isSelected: false, isRead: false) {}
                .listRowSeparator(.hidden)
                .listRowInsets(Constants.listInsets)
                .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}
