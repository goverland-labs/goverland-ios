//
//  ProposalListItemFooterView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct ProposalListItemFooterView: View {
    let proposal: Proposal
    
    var body: some View {
        HStack(spacing: 20) {
            VoteFooterView(votes: proposal.votes, quorum: proposal.quorum)
            Spacer()
            InboxListItemFooterMenu()
        }
    }
}

fileprivate struct VoteFooterView: View {
    let votes: Int
    let quorum: Int
    
    var body: some View {
        HStack(spacing: 10) {
            HStack(spacing: 5) {
                Image(systemName: "person.fill")
                    .foregroundColor(.gray)
                    .font(.footnoteRegular)
                
                Text(String(votes))
                    .fontWeight(.medium)
                    .font(.footnoteRegular)
            }
            
            HStack(spacing: 5) {
                Image(systemName: "flag.checkered")
                    .foregroundColor(.white)
                    .font(.footnoteRegular)
                
                Text(String(quorum))
                    .fontWeight(.medium)
                    .font(.footnoteRegular)
            }
        }
    }
}

struct ListItemFooter_Previews: PreviewProvider {
    static var previews: some View {
        ProposalListItemFooterView(proposal: .aaveTest)
    }
}
