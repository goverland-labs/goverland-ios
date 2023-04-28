//
//  ProposalListItemBodyView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct ProposalListItemBodyView: View {
    let data: VoteEventData
    let daoImage: URL?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(data.content.title)
                    .foregroundColor(.textWhite)
                    .font(.headlineSemibold)
                    .lineLimit(2)
                
                Text(data.content.subtitle)
                    .foregroundColor(data.status == .activeVote ? .primaryDim : .textWhite40)
                    .font(.footnoteRegular)
                    .lineLimit(1)
                
                if let warning = data.content.warningSubtitle {
                    Text(warning)
                        .foregroundColor(.textWhite40)
                        .font(.footnoteRegular)
                        .lineLimit(1)
                } else {
                    Text("")
                }
            }
            
            Spacer()
            
            RoundPictureView(image: daoImage, imageSize: 46)
        }
    }
}

struct ListItemBody_Previews: PreviewProvider {
    static var previews: some View {
        ProposalListItemBodyView(
            data: VoteEventData(user: User(address: .init(""), ensName: "", image: nil), status: .activeVote, content: .init(title: "", subtitle: "", warningSubtitle: ""), meta: .init(voters: 2, quorum: "", voted: true)),
            daoImage: URL(string: "")
        )
    }
}
