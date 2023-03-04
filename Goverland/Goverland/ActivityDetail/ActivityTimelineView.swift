//
//  ActivityTimelineView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-22.
//

import SwiftUI
import SwiftDate
import Kingfisher

struct ActivityTimelineView: View {
    
    private let user = User(address: "String0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                            image: "https://cdn.stamp.fyi/space/uniswap?s=164",
                            name: "uniman0.eth")
    
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
            .scaledToFit()
            .minimumScaleFactor(0.7)
        }
    }
}

struct ActivityTimelineView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityTimelineView()
    }
}
