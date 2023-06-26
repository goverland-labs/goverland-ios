//
//  ProposalListItemBodyView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct ProposalListItemBodyView: View {
    let proposal: Proposal
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(proposal.title)
                    .foregroundColor(.textWhite)
                    .font(.headlineSemibold)
                    .lineLimit(2)

                // TODO: implement
                Text("Finishes in 3 days")
                    .foregroundColor(proposal.state == .active ? .primaryDim : .textWhite40)
                    .font(.footnoteRegular)
                    .lineLimit(1)

                // TODO: fix
//                if let warning = data.content.warningSubtitle {
//                    Text(warning)
//                        .foregroundColor(.textWhite40)
//                        .font(.footnoteRegular)
//                        .lineLimit(1)
//                } else {
//                    Text("")
//                }
            }
            
            Spacer()
            
            RoundPictureView(image: proposal.dao.avatar, imageSize: 46)
        }
    }
}

struct ListItemBody_Previews: PreviewProvider {
    static var previews: some View {
        ProposalListItemBodyView(proposal: .aaveTest)
    }
}
