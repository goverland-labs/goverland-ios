//
//  ProposalListItemFooterView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct ProposalListItemFooterView: View {
    let meta: InboxEventMetaInfo?
    
    var body: some View {
        HStack(spacing: 20) {
            if let meta = meta as? InboxEventsDiscussionMeta {
                DiscussionFooterView(meta: meta)
            } else if let meta = meta as? InboxEventsVoteMeta {
                VoteFooterView(meta: meta)
            }

            Spacer()
            
            InboxListItemFooterMenu()
        }
    }
}

fileprivate struct DiscussionFooterView: View {
    var meta: InboxEventsDiscussionMeta

    var body: some View {
        HStack(spacing: 10) {
            HStack(spacing: 5) {
                Image(systemName: "text.bubble.fill")
                    .foregroundColor(.gray)
                    .font(.system(size: 10))

                Text(String(meta.comments))
                    .fontWeight(.medium)
                    .font(.system(size: 13))
            }

            HStack(spacing: 5) {
                Image(systemName: "eye.fill")
                    .foregroundColor(.gray)
                    .font(.system(size: 10))

                Text(String(meta.views))
                    .fontWeight(.medium)
                    .font(.system(size: 13))
            }

            HStack(spacing: 5) {
                Image(systemName: "person.2.fill")
                    .foregroundColor(.gray)
                    .font(.system(size: 10))

                Text(String(meta.views))
                    .fontWeight(.medium)
                    .font(.system(size: 13))
            }
        }
    }
}

fileprivate struct VoteFooterView: View {
    var meta: InboxEventsVoteMeta
    
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
            meta: InboxEventsVoteMeta(voters: 1, quorum: "1", voted: true))
    }
}
