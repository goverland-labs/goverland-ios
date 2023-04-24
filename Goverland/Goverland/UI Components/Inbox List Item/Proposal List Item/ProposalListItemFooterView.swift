//
//  ProposalListItemFooterView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct ProposalListItemFooterView: View {
    let meta: VoteEventData.VoteMeta
    
    var body: some View {
        HStack(spacing: 20) {
            VoteFooterView(meta: meta)
            Spacer()
            InboxListItemFooterMenu()
        }
    }
}

fileprivate struct VoteFooterView: View {
    var meta: VoteEventData.VoteMeta
    
    var body: some View {
        HStack(spacing: 10) {
            HStack(spacing: 5) {
                Image(systemName: "person.fill")
                    .foregroundColor(.gray)
                    .font(.footnoteRegular)
                
                Text(String(meta.voters))
                    .fontWeight(.medium)
                    .font(.footnoteRegular)
            }
            
            HStack(spacing: 5) {
                Image(systemName: "flag.checkered")
                    .foregroundColor(.white)
                    .font(.footnoteRegular)
                
                Text(meta.quorum)
                    .fontWeight(.medium)
                    .font(.footnoteRegular)
            }
            
            if meta.voted {
                HStack(spacing: 1) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 9))
                        .foregroundColor(.textWhite)
                    
                    Text("voted")
                        .font(.caption2Semibold)
                        .foregroundColor(.textWhite)
                        .lineLimit(1)
                }
                .padding(5)
                .background(Capsule().fill(Color.success))
            }
        }
    }
}

struct ListItemFooter_Previews: PreviewProvider {
    static var previews: some View {
        ProposalListItemFooterView(
            meta: VoteEventData.VoteMeta(voters: 1, quorum: "1", voted: true))
    }
}
