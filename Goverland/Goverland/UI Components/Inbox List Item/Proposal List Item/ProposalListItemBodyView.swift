//
//  ProposalListItemBodyView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI

struct ProposalListItemBodyView: View {
    let content: VoteEventData.VoteContent
    let daoImage: URL?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(content.title)
                    .foregroundColor(.textWhite)
                    .font(.headlineSemibold)
                    .lineLimit(2)
                
                Text(content.subtitle)
                    .foregroundColor(.textWhite40)
                    .font(.footnoteRegular)
                    .lineLimit(1)
                
                if let warning = content.warningSubtitle {
                    Text(warning)
                        .foregroundColor(.textWhite40)
                        .font(.footnoteRegular)
                        .lineLimit(1)
                } else {
                    Text("")
                }
            }
            
            Spacer()
            
            DaoPictureView(daoImage: daoImage, imageSize: 46)
        }
    }
}

struct ListItemBody_Previews: PreviewProvider {
    static var previews: some View {
        ProposalListItemBodyView(
            content: VoteEventData.VoteContent(title: "", subtitle: "", warningSubtitle: ""),
            daoImage: URL(string: "")
        )
    }
}
