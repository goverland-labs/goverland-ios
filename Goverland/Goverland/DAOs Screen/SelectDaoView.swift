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
                        ForEach(data.keys, id: \.self) { key in
                            VStack {
                                HStack {
                                    Text(key.name)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Text("See all")
                                        .fontWeight(.medium)
                                        .foregroundColor(.blue)
                                }
                                .padding()
                                
                                DaoGroupThread(daoGroups: $data.daoGroups, daoGroupType: key, data: data)
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

struct DaoGroupThread: View {
    @Binding var daoGroups: [DaoGroupType: [Dao]]
    var daoGroupType: DaoGroupType
    var data: DaoDataService
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(0..<daoGroups[daoGroupType]!.count, id: \.self) { index in
                    if index == daoGroups[daoGroupType]!.count - 1 && data.hasNextPageURL(forGroupType: daoGroupType) {
                        DaoGroupItemView(dao: daoGroups[daoGroupType]![index])
                            .redacted(reason: .placeholder)
                            .onAppear {
                                data.getMoreDaos(inGroup: daoGroupType)
                            }
                    } else {
                        DaoGroupItemView(dao: daoGroups[daoGroupType]![index])
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
}

struct DaoGroupItemView: View {
    
    var dao: Dao
    
    var body: some View {
        VStack(spacing: 12) {
            DaoImageView(imageURL: dao.image)
            Text(dao.name)
                .fontWeight(.medium)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.8)
            Spacer()
            FollowButtonView()
        }
        .frame(width: 130, height: 200)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color("lightGrey"), lineWidth: 1)
        )
    }
}


fileprivate struct DaoImageView: View {
    
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


fileprivate struct FollowButtonView: View {
    
    @State private var didTap: Bool = false
    
    var body: some View {
        Button(action: { followAction() }) {
            Text(didTap ? "Following" : "Follow")
            }
            .frame(width: 110, height: 35, alignment: .center)
            .foregroundColor(didTap ? .blue : .white)
            .fontWeight(.medium)
            .background(didTap ? Color("followButtonColorActive") : Color.blue)
            .cornerRadius(5)
    }
    
    private func followAction() {
        if didTap {
            didTap = false
        } else {
            didTap = true
        }
    }
}

struct SelectDAOsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectDaoView()
    }
}
