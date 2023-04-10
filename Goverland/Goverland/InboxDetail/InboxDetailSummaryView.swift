//
//  InboxDetailSummaryView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-18.
//

import SwiftUI

struct InboxDetailSummaryView: View {
    
    let user: User
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 5) {
                Text("Summary")
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("Author")
                
                UserPictureView(userImage: user.image, imageSize: 15)
                
                if let name = user.ensName {
                    Text(name)
                        .lineLimit(1)
                } else {
                    Text(user.address)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
            }
            
            Text("Boba Network and Franklin DAO (Prev. Penn Blockchain) are submitting this proposal to Deploy Uniswap v3 on Boba Network. Summary In cooperation with DMA Labs (a major contributor to ICHI’s Uniswap v3 management protocol (http://www.ichi.org)) and support of furthering the vision of Multichain Uniswap 15, we propose that the Uniswap community vote to authorize the deployment of Uniswap v3 to Boba Network. Boba Network is a blockchain Layer 2 scaling solution and Hybrid Computing…")
                .lineSpacing(5)
            
            Text("[Read full summary](https://google.com)")
                .fontWeight(.semibold)
        }
    }
}

struct InboxDetailSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        InboxDetailSummaryView(user: User(address: "", image: URL(string: ""), name: ""))
    }
}
