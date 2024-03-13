//
//  PublicUserProfileView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-03-07.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

struct PublicUserProfileView: View {
    @StateObject private var dataSource: PublicUserProfileDataSource
    @State private var showSignIn = false
    
    init(address: Address) {
        _dataSource = StateObject(wrappedValue: PublicUserProfileDataSource(address: address))
    }
    
    var body: some View {
        Group {
            if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the profile")
            } else if dataSource.profile == nil {
                _ShimmerProfileHeaderView()
                Spacer()
            } else if let profile = dataSource.profile {
                _ProfileHeaderView(user: profile.user)

                FilterButtonsView<PublicProfileFilter>(filter: $dataSource.filter) { _ in }
                
                switch dataSource.filter {
                case .activity:
                    PublicUserProfileActivityView(dataSource: dataSource)
                }
            }
        }
        .sheet(isPresented: $showSignIn) {
            SignInTwoStepsView()
                .presentationDetents([.height(500), .large])
        }
        .onAppear {
            Tracker.track(.screenProfile)
            if dataSource.profile == nil {
                dataSource.refresh()
            }
        }
    }
}
