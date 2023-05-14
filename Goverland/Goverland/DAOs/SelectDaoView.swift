//
//  SelectDaoView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-30.
//

import SwiftUI

struct SelectDaoView: View {
    @State private var searchedText: String = ""
    @StateObject private var data = DaoDataSource()
    
    var body: some View {
        NavigationStack {
            VStack {
                if searchedText == "" {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            Text("Get Updates in your feed for the DAOs you select.")
                                .font(.subheadlineRegular)
                                .foregroundColor(.textWhite)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            ForEach(data.caregories) { category in
                                VStack(spacing: 8) {
                                    HStack {
                                        Text(category.name)
                                            .font(.subheadlineSemibold)
                                            .foregroundColor(.textWhite)
                                        Spacer()
                                        NavigationLink("See all", value: category)
                                            .font(.subheadlineSemibold)
                                            .foregroundColor(.primaryDim)
                                    }
                                    .padding(.top, 20)
                                    DaoGroupThreadView(category: category)
                                }
                            }
                        }
                    }
                    NavigationLink {
                        EnablePushNotificationsView()
                    } label: {
                        Text("Continue")
                            .ghostActionButtonStyle()
                            .padding(.vertical)
                    }
                } else {
                    FollowDaoListView(category: .social)
                }
            }
            .navigationDestination(for: DaoCategory.self) { category in
                FollowDaoListView(category: category)
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
            .onAppear() {
                data.loadCategories()
                Tracker.track(.selectDaoView)
            }
        }
    }
}

struct DaoGroupThreadView: View {
    @StateObject var data = DaoDataSource()
    let category: DaoCategory
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(0..<data.daos.count, id: \.self) { index in
                    DaoCardView(dao: data.daos[index])
                }
            }
            .onAppear() {
                data.loadData(category: category)
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
