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
            VStack {
                if searchedText == "" {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            Text("Get Updates in your feed for the DAOs you select.")
                                .font(.subheadlineRegular)
                                .foregroundColor(.textWhite)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            ForEach(data.keys, id: \.self) { key in
                                VStack(spacing: 8) {
                                    HStack {
                                        Text(key.name)
                                            .font(.subheadlineSemibold)
                                            .foregroundColor(.textWhite)
                                        Spacer()
                                        Text("See all")
                                            .font(.subheadlineSemibold)
                                            .foregroundColor(.primaryDim)
                                    }
                                    .padding(.top, 20)
                                    DaoGroupThreadView(daoGroups: $data.daoGroups, daoGroupType: key, data: data)
                                }
                            }
                        }
                    }
                    NavigationLink(destination: EnablePushNotificationsView()) {
                        Text("Continue")
                            .ghostActionButtonStyle()
                            .padding(.vertical)
                    }
                } else {
                    FollowDaoListView()                    
                }
            }
            .padding(.horizontal, 15)
            .searchable(text: $searchedText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Search 6032 DAOs by name")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Select DAOs")
                            .font(.title3Semibold)
                            .foregroundColor(Color.textWhite)
                    }
                }
            }
            .onAppear() { Tracker.track(.selectDaoView) }
        }
    }
}

struct DaoGroupThreadView: View {
    @Binding var daoGroups: [DaoCategory: [Dao]]
    var daoGroupType: DaoCategory
    var data: DaoDataService
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
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
        .padding(.bottom, 20)
    }
}

fileprivate struct DaoCardView: View {
    var dao: Dao
    
    var body: some View {
        VStack {
            RoundPictureView(image: dao.image, imageSize: 90)
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
        .frame(width: 130, height: 200)
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
