//
//  ActivityDetailForumView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-18.
//

import SwiftUI
import Kingfisher

struct ActivityDetailForumView: View {
    @Environment(\.colorScheme) var colorScheme
    private let user = User(address: "String0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                            image: "https://cdn.stamp.fyi/space/uniswap?s=164",
                            name: "uniman_ETH1f99999999999")
    var body: some View {
        HStack {
            Button(action: openDiscussionForum) {
                KFImage(URL(string: user.image))
                    .placeholder {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .aspectRatio(contentMode: .fill)
                            .foregroundColor(.gray)
                    }
                    .resizable()
                    .setProcessor(ResizingImageProcessor(referenceSize: CGSize(width: 40, height: 40), mode: .aspectFill))
                    .frame(width: 40, height: 40)
                    .cornerRadius(20)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("View forum discussion")
                        .fontWeight(.semibold)
                        
                    
                    HStack(spacing: 3) {
                        Image(systemName: "ellipsis.message.fill")
                            .foregroundColor(colorScheme == .light ? .gray : .white)
                        Text("21")
                            .foregroundColor(colorScheme == .light ? .black : .white)
                        Text("comments")
                            .foregroundColor(colorScheme == .light ? .black : .white)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.forward")
                    .foregroundColor(.gray)
            }
            .padding(10)
            .background(colorScheme == .light ? Color("lightGrey") : .darkGray)
            .cornerRadius(10)
        }
    }
    
    private func openDiscussionForum() {}
}

struct ActivityDetailForumView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailForumView()
    }
}
