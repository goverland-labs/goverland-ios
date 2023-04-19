//
//  SelectDaoView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-30.
//

import SwiftUI

struct SelectDaoView: View {
    @StateObject private var data = DaoDataService()
    @State private var searchedText: String = ""
    
    var body: some View {
        NavigationView {
            VStack{
                if searchedText == "" {
                    Text("Get Updates in your feed for the DAOs you select.")
                        .padding()
                    ScrollView(showsIndicators: false) {
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
                                    
                                    DaoGroupThreadView(daoGroups: $data.daoGroups, daoGroupType: key, data: data)
                                }
                            }
                        }
                    }
                    .onAppear() { Tracker.track(.selectDaoView) }
                    NavigationLink(destination: EnablePushNotificationsView()) {
                        Text("Continue")
                            .ghostActionButtonStyle()
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        ForEach(data.daoGroups[.social]!) { dao in
                            HStack {
                                DaoPictureView(daoImage: dao.image, imageSize: 50)
                                Text(dao.name)
                                Spacer()
                                FollowButtonView(buttonWidth: 110, buttonHeight: 35)
                            }
                            .padding(5)
                            .listRowSeparator(.hidden)
                        }
                        .padding()
                    }
                }
            }
            .searchable(text: $searchedText)
            .navigationBarTitle("Select DAOs")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DaoGroupThreadView: View {
    @Binding var daoGroups: [DaoGroupType: [Dao]]
    var daoGroupType: DaoGroupType
    var data: DaoDataService
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(0..<daoGroups[daoGroupType]!.count, id: \.self) { index in
                    if index == daoGroups[daoGroupType]!.count - 1 && data.hasNextPageURL(forGroupType: daoGroupType) {
                        DaoCardView(dao: daoGroups[daoGroupType]![index])
                            .redacted(reason: .placeholder)
                            .onAppear {
                                data.getMoreDaos(inGroup: daoGroupType)
                            }
                    } else {
                        DaoCardView(dao: daoGroups[daoGroupType]![index])
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
}

fileprivate struct DaoCardView: View {
    var dao: Dao
    
    var body: some View {
        VStack {
            DaoPictureView(daoImage: dao.image, imageSize: 90)
            VStack(spacing: 3) {
                Text(dao.name)
                    .fontWeight(.semibold)
                    .font(.headline)
                    .foregroundColor(.textWhite)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                Text("18.2K members")
                    .font(.сaption2Regular)
                    .foregroundColor(.textWhite60)
            }
            Spacer()
            FollowButtonView(buttonWidth: 110, buttonHeight: 35)
        }
        .frame(width: 140, height: 200)
        .padding(.vertical, 30)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.container))
    }
}

struct SelectDAOsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectDaoView()
    }
}
