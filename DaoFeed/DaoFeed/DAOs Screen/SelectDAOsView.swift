//
//  SelectDAOsView.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2023-01-30.
//

import SwiftUI
import Kingfisher

struct SelectDAOsView: View {
    
    @StateObject private var data = SelectDAOsDataService.data
    
    var body: some View {
        VStack{
            Text("Select DAOs")
                .font(.title2)
                .fontWeight(.semibold)
                .padding()
            
            SearchBarView()
            
            Text("Get Updates in your feed for the DAOs you select.")
                .padding()
            ScrollView {
                VStack {
                    ForEach(0..<data.daosGroups.count, id: \.self) { index in
                        VStack {
                            DAOsGroupThreadView(daosGroup: data.daosGroups[index])
                        }
                    }
                }
            }
            Button("Continue", action: continueButtonTapped)
                .frame(maxWidth: .infinity, maxHeight: 60, alignment: .center)
                .background(Color.blue)
                .clipShape(Capsule())
                .tint(.white)
                .fontWeight(.bold)
                .padding(.horizontal, 30)
        }
    }
    func continueButtonTapped() {}
}

struct DAOsGroupThreadView: View {
    
    let daosGroup: DAOsGroup
    
    var body: some View {
            
        HStack {
            Text(daosGroup.groupType.rawValue.capitalized)
                .fontWeight(.semibold)
            Spacer()
            Text("See all")
                .fontWeight(.medium)
                .foregroundColor(.blue)
        }
        .padding()
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(0..<daosGroup.daos.count, id: \.self) { index in
                    VStack {
                        daoImageView(imageURL: daosGroup.daos[index].image)
                        Text(daosGroup.daos[index].name)
                            .fontWeight(.medium)
                        Button("Follow", action: followAction)
                            .frame(width: 110, height: 35, alignment: .center)
                            .foregroundColor(.white)
                            .fontWeight(.medium)
                            .background(.blue)
                            .cornerRadius(2)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color("lightGrey"), lineWidth: 1)
                    )
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
    func followAction() {}
}

fileprivate struct daoImageView: View {
    
    var imageURL: URL?
    
    var body: some View {
        KFImage(imageURL)
            .placeholder {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 90, height: 90)
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.gray)
            }
            .resizable()
            .setProcessor(ResizingImageProcessor(referenceSize: CGSize(width: 90, height: 90), mode: .aspectFill))
            .frame(width: 90, height: 90)
            .cornerRadius(45)
    }
    
}

struct SelectDAOsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectDAOsView()
    }
}
