//
//  ListItemHeaderImageView.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-30.
//

import SwiftUI
import Kingfisher

struct ListItemHeaderImageView: View {
    
    var event: Event
    private let user = User(address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b", image: "https://cdn-icons-png.flaticon.com/512/17/17004.png?w=1060&t=st=1672407609~exp=1672408209~hmac=7cb92bf848bb316a8955c5f510ce50f48c6a9484fb3641fa70060c212c2a8e39", name: "")
    
    
    var body: some View {
        let url = URL(string: user.image)
        KFImage(url)
            .placeholder {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.purple)
            }
            .resizable()
            .setProcessor(ResizingImageProcessor(referenceSize: CGSize(width: 15, height: 15), mode: .aspectFit))
    }
}

struct ListItemHeaderImageView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemHeaderImageView(event: Event(type: .discussion, meta: []))
    }
}
