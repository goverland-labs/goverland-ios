//
//  DaoInfoScreenHeaderView().swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-07.
//

import SwiftUI
import Kingfisher

struct DaoInfoScreenHeaderView: View {
    
    private let user = User(address: "", image: "https://cdn.stamp.fyi/space/uniswap?s=164", name: "")
    
    var body: some View {
        HStack {
            KFImage(URL(string: user.image))
                .placeholder {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .aspectRatio(contentMode: .fill)
                        .foregroundColor(.purple)
                }
                .resizable()
                .setProcessor(ResizingImageProcessor(referenceSize: CGSize(width: 100, height: 100), mode: .aspectFit))
                .frame(width: 100, height: 100)
                .cornerRadius(50)
            
            Spacer()
            
            HStack(spacing: 10) {
                VStack {
                    Text("103")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Proposales")
                }
                
                VStack {
                    Text("342.9K")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Holders")
                }
                
                VStack {
                    Text("$2.8B")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Treasury")
                }
            }
            .scaledToFill()
            .minimumScaleFactor(0.5)
            .lineLimit(1)
        }
    }
}

struct DaoInfoScreenHeaderViewPreviews: PreviewProvider {
    static var previews: some View {
        DaoInfoScreenHeaderView()
    }
}
