//
//  ActivityDetailSummaryView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-18.
//

import SwiftUI
import Kingfisher

struct ActivityDetailSummaryView: View {
    
    private let user = User(address: "String0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                            image: "https://cdn.stamp.fyi/space/uniswap?s=164",
                            name: "uniman0.eth")
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 5) {
                Text("Summary")
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("Author")
                
                KFImage(URL(string: ""))
                    .placeholder {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .aspectRatio(contentMode: .fill)
                            .foregroundColor(.purple)
                    }
                    .resizable()
                    .setProcessor(ResizingImageProcessor(referenceSize: CGSize(width: 15, height: 15), mode: .aspectFit))
                    .frame(width: 15, height: 15)
                
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

struct ActivityDetailSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailSummaryView()
    }
}
