//
//  ActivityListItemBodyView.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI
import Kingfisher

struct ActivityListItemBodyView: View {
    
    var event: ActivityEvent
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 5) {
                
                Text(event.content.title)
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .lineLimit(2)
                
                Text(event.content.subtitle)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                if let warning = event.content.warningSubtitle {
                    Text(warning)
                        .foregroundColor(.yellow)
                        .lineLimit(2)
                } else {
                    Text("")
                }
            }
            
            Spacer()
            
            ActivityListItemBodyImageView(event: event)
                .frame(width: 50, height: 50)
        }
    }
}

fileprivate struct ActivityListItemBodyImageView: View {
    
    var event: ActivityEvent
    
    var body: some View {
        
        let url = URL(string: event.daoImage)
        
        KFImage(url)
            .placeholder {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.gray)
            }
            .resizable()
            .setProcessor(ResizingImageProcessor(referenceSize: CGSize(width: 50, height: 50), mode: .aspectFill))
    }
}

struct ListItemBody_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListItemBodyView(event: ActivityEvent(
            user: User(
                address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                image: "https://cdn-icons-png.flaticon.com/512/17/17004.png?w=1060&t=st=1672407609~exp=1672408209~hmac=7cb92bf848bb316a8955c5f510ce50f48c6a9484fb3641fa70060c212c2a8e39",
                name: "safe1.sche.eth"),
            date: Date(),
            type: .discussion,
            status: .discussion,
            content: ActivityViewContent(title: "", subtitle: "", warningSubtitle: ""),
            daoImage: "",
            meta: ["", "", ""]))
    }
}
