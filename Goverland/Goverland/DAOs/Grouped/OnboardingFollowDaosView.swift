//
//  OnboardingFollowDaosView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-30.
//

import SwiftUI

struct OnboardingFollowDaosView: View {
    @StateObject private var dataSource = GroupedDaosDataSource()    

    private var searchPrompt: String {
        if let totalDaos = dataSource.totalDaos.map(String.init) {
            return "Search for \(totalDaos) DAOs by name"
        }
        return ""
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if dataSource.searchText == "" {
                    if !dataSource.failedToLoadInitially {
                        GroupedDaosView(dataSource: dataSource, displayCallToAction: true)
                        NavigationLink {
                            EnablePushNotificationsView()
                        } label: {
                            // TODO: make button disabled logic
                            Text("Continue")
                                .ghostActionButtonStyle()
                                .padding(.vertical)
                        }
                    } else {
                        RetryInitialLoadingView(dataSource: dataSource)
                    }
                } else {
                    DaosSearchListView(dataSource: dataSource)
                }
            }
            .padding(.horizontal, 15)
            .searchable(text: $dataSource.searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: searchPrompt)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Follow DAOs")
                            .font(.title3Semibold)
                            .foregroundColor(Color.textWhite)
                    }
                }
            }
            .onAppear() {
                dataSource.refresh()
                Tracker.track(.selectDaoView)                
            }
        }
        .accentColor(.primary)
    }
}




struct SelectDAOsView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFollowDaosView()
    }
}
