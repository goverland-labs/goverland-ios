//
//  ListItemHeader.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2022-12-21.
//

import SwiftUI


struct ListItemHeader: View {
    
    var event: Event
    private let user = User(address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b", image: "https://example.org/image.jpg", name: "")
    
    var body: some View {
        HStack {
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 15, height: 15)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.purple)
            
            
            
            // this logic should be in ViewModel
            if user.endName != ""  {
                Text(user.endName)
                    .fontWeight(.semibold)
                    .lineLimit(1)
            } else {
                Text(user.address)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            
            Text("2 days ago")
                .foregroundColor(.gray)
            
            Spacer()
            
            ListItemStatusBubbleView()
        }
    }
}

// TODO: Move to models

struct User {
    
    var address: String
    var endName: String
    var image: String
    
    init(address: String, image: String, name: String) {
        self.address = address
        self.endName = name
        self.image = image
    }
}


struct ListItemHeader_Previews: PreviewProvider {
    static var previews: some View {
        ListItemHeader(event: Event(type: .discussion))
    }
}
