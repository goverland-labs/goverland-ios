//
//  ActivityDetailHeader.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-18.
//

import SwiftUI
import Kingfisher

struct ActivityDetailHeaderView: View {
    
    private let user = User(address: "String0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                            image: "https://cdn.stamp.fyi/space/uniswap?s=164",
                            name: "uniman_ETH1f99999999999")
    
    var body: some View {
        HStack(spacing: 12) {
            KFImage(URL(string: user.image))
                .placeholder {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .aspectRatio(contentMode: .fill)
                        .foregroundColor(.gray)
                }
                .resizable()
                .setProcessor(ResizingImageProcessor(referenceSize: CGSize(width: 50, height: 50), mode: .aspectFill))
                .frame(width: 50, height: 50)
            
            Text("Deplay Uniswap V3 on StarkNet")
                .fontWeight(.semibold)
            
            Spacer()
        }
        
    }
}

struct ActivityDetailHeader_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailHeaderView()
    }
}
