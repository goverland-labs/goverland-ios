//
//  PublicProfileView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-03-07.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

struct PublicProfileView: View {
    @StateObject private var dataSource = PublicProfileDataSource
    @State private var showSignIn = false
    
    init(address: Address) {
        _dataSource = StateObject(wrappedValue: PublicProfileDataSource(address: address))
    }
    
    var body: some View {
        Group {
            if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the profile")
            } else if dataSource.profile == nil {
                _ShimmerProfileHeaderView()
                Spacer()
            } else if let profile = dataSource.profile {
                ProfileHeaderView(profile: dataSource.profile)
                
                FilterButtonsView<PublicProfileFilter>(filter: $dataSource.filter) { _ in }
                
                switch dataSource.filter {
                case .activity:
                    PublicProfileActivityView(dataSource: dataSource)
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

fileprivate struct ProfileHeaderView: View {
    let profile: PublicProfile
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(spacing: 12) {
                RoundPictureView(image: profile.user.avatar(size: .l), imageSize: Avatar.Size.l.profileImageSize)
                ZStack {
                    if let name = profile.user.resolvedName {
                        Text(name)
                            .truncationMode(.tail)
                    } else {
                        Button {
                            UIPasteboard.general.string = profile.user.address.value
                            showToast("Address copied")
                        } label: {
                            Text(profile.user.address.short)
                        }
                    }
                }
                .font(.title3Semibold)
                .lineLimit(1)
                .foregroundStyle(Color.textWhite)
            }
            .padding(.bottom, 6)
        }
        .padding(24)
    }
}


fileprivate struct _ShimmerProfileHeaderView: View {
    var body: some View {
        VStack(alignment: .center) {
            ShimmerView()
                .frame(width: Avatar.Size.l.profileImageSize, height: Avatar.Size.l.profileImageSize)
                .cornerRadius(Avatar.Size.l.profileImageSize / 2)
            
            ShimmerView()
                .cornerRadius(24)
                .frame(width: 100, height: 24)
        }
        .padding(24)
    }
}
