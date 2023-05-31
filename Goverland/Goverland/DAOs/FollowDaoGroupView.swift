//
//  FollowDaoGroupView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-30.
//

import SwiftUI

struct FollowDaoGroupView: View {
    @State private var searchedText: String = ""
    @StateObject private var dataSource = GroupDaosDataSource()
    
    var body: some View {
        NavigationStack {
            VStack {
                if searchedText == "" {
                    if !dataSource.failedToLoadInitially {
                        GroupedView(dataSource: dataSource)
                    } else {
                        InitialLoadingFailedView()
                    }
                    NavigationLink {
                        EnablePushNotificationsView()
                    } label: {
                        Text("Continue")
                            .ghostActionButtonStyle()
                            .padding(.vertical)
                    }
                } else {
                    // TODO: implement search logic
                    FollowDaoListView(category: .social)
                }
            }
            .navigationDestination(for: DaoCategory.self) { category in
                FollowDaoListView(category: category)
            }
            .padding(.horizontal, 15)
            .searchable(text: $searchedText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        // TODO: make dao/top return total count of DAOs
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
                dataSource.loadInitialData()
                Tracker.track(.selectDaoView)                
            }
        }
    }
}

fileprivate struct GroupedView: View {
    @ObservedObject var dataSource: GroupDaosDataSource

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text("Get Updates in your feed for the DAOs you select.")
                    .font(.subheadlineRegular)
                    .foregroundColor(.textWhite)
                    .frame(maxWidth: .infinity, alignment: .leading)
                ForEach(DaoCategory.values) { category in
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
                        DaoGroupThreadView(dataSource: dataSource, category: category)
                    }
                }
            }
        }
    }
}

fileprivate struct DaoGroupThreadView: View {
    @ObservedObject var dataSource: GroupDaosDataSource
    let category: DaoCategory

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                if dataSource.categoryDaos[category] == nil { // initial loading
                    // TODO: shimmering view
                    ForEach(0..<3) { _ in
                        Circle().foregroundColor(.yellow)
                    }
                } else {
                    let count = dataSource.categoryDaos[category]!.count
                    ForEach(0..<count, id: \.self) { index in
                        let dao = dataSource.categoryDaos[category]![index]
                        if index == count - 1 && dataSource.hasMore(category: category) {
                            if !dataSource.failedToLoad(category: category) { // try to paginate
                                // TODO: shimmering view
                                ShimmerLoadingItemView()
                                    .cornerRadius(20)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 8)
                                    .frame(height: 90)
                                    .onAppear {                                        
                                        dataSource.loadMore(category: category)
                                    }
                            } else { // display retry pagination view
                                // TODO: implement retry loading view
                                Circle().foregroundColor(.gray)
                            }
                        } else {
                            DaoCardView(dao: dao)
                        }
                    }
                }
            }
        }
        .padding(.bottom, 20)
    }
}

fileprivate struct DaoCardView: View {
    let dao: Dao

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

fileprivate struct InitialLoadingFailedView: View {
    var body: some View {
        // TODO: implement
        Text("INITIAL LOADING FAILED")
    }
}

struct SelectDAOsView_Previews: PreviewProvider {
    static var previews: some View {
        FollowDaoGroupView()
    }
}
