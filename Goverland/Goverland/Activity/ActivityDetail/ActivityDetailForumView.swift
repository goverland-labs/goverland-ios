//
//  ActivityDetailForumView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-18.
//

import SwiftUI
import Kingfisher

struct ActivityDetailForumView: View {
    
    private let user = User(address: "String0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                            image: "https://cdn.stamp.fyi/space/uniswap?s=164",
                            name: "uniman_ETH1f99999999999")
    var body: some View {
        HStack {
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
                .cornerRadius(25)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("View forum discussion")
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                
                HStack(spacing: 3) {
                    Image(systemName: "ellipsis.message.fill")
                        .foregroundColor(.gray)
                    Text("21")
                    Text("comments")
                    
                }
            }
            
            Spacer()
        }
        .padding(15)
        .background(Color("lightGrey"))
        .cornerRadius(10)
        
    }
}

struct ActivityDetailForumView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailForumView()
    }
}
