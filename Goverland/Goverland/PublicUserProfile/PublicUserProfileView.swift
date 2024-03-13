//
//  PublicUserProfileView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-03-07.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

enum PublicUserProfileScreen: Hashable {
    case votedInDaos
    case votes
    case vote(Proposal)
}

struct PublicUserProfileView: View {
    @StateObject private var dataSource: PublicUserProfileDataSource
    @State private var path = [PublicUserProfileScreen]()

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

                FilterButtonsView<PublicUserProfileFilter>(filter: $dataSource.filter) { _ in }

                switch dataSource.filter {
                case .activity:
                    _PublicUserProfileListView(profile: profile, address: dataSource.address, path: $path)
                }
            }
        }
        .onAppear {
            // TODO: tracking
//            Tracker.track(.screenProfile)
            if dataSource.profile == nil {
                dataSource.refresh()
            }
        }
    }
}

fileprivate struct _PublicUserProfileListView: View {
    let profile: PublicUserProfile
    let address: Address
    @Binding var path: [PublicUserProfileScreen]

    var body: some View {
        ScrollView {
            _VotedInDaosView(profile: profile)
            PublicUserProfileActivityView(address: address, path: $path)
        }
    }
}

fileprivate struct _VotedInDaosView: View {
    let profile: PublicUserProfile

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Voted in DAOs (\(profile.votedInDaos.count))")
                    .font(.subheadlineSemibold)
                    .foregroundStyle(Color.textWhite)
                Spacer()
                // TODO: adjust
                NavigationLink("See all", value: PublicUserProfileScreen.votedInDaos)
                    .font(.subheadlineSemibold)
                    .foregroundStyle(Color.primaryDim)
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)

            if profile.votedInDaos.count == 0 {
                Text("User has not voted yet")
                    .foregroundStyle(Color.textWhite)
                    .font(.bodyRegular)
                    .padding(16)
            } else {
                HStack(spacing: 16) {
                    ForEach(profile.votedInDaos) { dao in
                        RoundPictureView(image: dao.avatar(size: .m), imageSize: Avatar.Size.m.daoImageSize)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.containerBright)
                .cornerRadius(20)
                .padding(.horizontal, 8)
            }
        }
    }
}
