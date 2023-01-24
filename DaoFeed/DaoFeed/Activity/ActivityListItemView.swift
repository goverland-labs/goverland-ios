//
//  ActivityListItemView.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-28.
//

import SwiftUI

struct ActivityListItemView: View {
    
    var event: ActivityEvent
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 5)
                .fill(.white)
                .padding(.horizontal, -12)

            VStack(spacing: 15) {
                ActivityListItemHeaderView(event: event)
                ActivityListItemBodyView(event: event)
                ActivityListItemFooterView(event: event)
            }
        }
    }
}

struct ActivityListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListItemView(event: ActivityEvent(
            id: UUID(),
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
