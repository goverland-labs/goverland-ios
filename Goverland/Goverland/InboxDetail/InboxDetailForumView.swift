//
//  InboxDetailForumView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-18.
//

import SwiftUI

struct InboxDetailForumView: View {
    let event: InboxEvent
    var body: some View {
        HStack {
            Button(action: openDiscussionForum) {
                RoundPictureView(image: event.daoImage, imageSize: 40)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("View forum discussion")
                        .fontWeight(.semibold)
                        
                    
                    HStack(spacing: 3) {
                        Image(systemName: "ellipsis.message.fill")
                            .foregroundColor(.gray)
                        Text("21")
                            .foregroundColor(.primary)
                        Text("comments")
                            .foregroundColor(.primary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.forward")
                    .foregroundColor(.gray)
            }
            .padding(10)
            .background(Color.gray)
            .cornerRadius(10)
        }
    }
    
    private func openDiscussionForum() {}
}

struct InboxDetailForumView_Previews: PreviewProvider {
    static var previews: some View {
        InboxDetailForumView(event: InboxEvent.vote1)
    }
}
