//
//  ActivityTimelineView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-22.
//

import SwiftUI
import SwiftDate

struct ActivityTimelineView: View {
    
    let user: User
    
    var body: some View {
        VStack {
            HStack {
                Text("Timeline")
                    .fontWeight(.bold)
                    
                Spacer()
            }
            
            HStack {
                Text(Date().toFormat("MMM d, yyyy"))
                Text("—") // em-dash
                Text("Discussion")
                    .foregroundColor(.blue)
                Text("started by")
                
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
            .scaledToFit()
            .minimumScaleFactor(0.7)
        }
    }
}

struct ActivityTimelineView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityTimelineView(user: User(address: "", image: URL(string: ""), name: ""))
    }
}
