//
//  SelectDaoView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-30.
//

import SwiftUI
import Kingfisher

struct SelectDaoView: View {
    
    @StateObject private var data = DaoDataService.data
    @State private var searchedText: String = ""
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Get Updates in your feed for the DAOs you select.")
                    .padding()
                ScrollView {
                    VStack {
                        ForEach(0..<data.daosGroups.count, id: \.self) { index in
                            VStack {
                                DaoGroupThreadView(daosGroup: data.daosGroups[index])
                            }
                        }
                    }
                }
                Button("Continue", action: continueButtonTapped)
                    .ghostActionButtonStyle()
            }
            .searchable(text: $searchedText)
            .navigationBarTitle("Select DAOs")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func continueButtonTapped() {}
}

struct DaoGroupThreadView: View {
    
    let daosGroup: DaoGroup
    @StateObject private var data = DaoDataService.data
    
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
                        VStack(spacing: 12) {
                            daoImageView(imageURL: daosGroup.daos[index].image)
                            Text(daosGroup.daos[index].name)
                                .fontWeight(.medium)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.8)
                            Spacer()
                            Button("Follow", action: followAction)
                                .frame(width: 110, height: 35, alignment: .center)
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                                .background(.blue)
                                .cornerRadius(2)
                        }
                        .frame(width: 130, height: 200)
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
    private func followAction() {
        //change button color
    }
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
        SelectDaoView()
    }
}
