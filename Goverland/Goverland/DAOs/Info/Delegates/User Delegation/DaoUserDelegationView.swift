//
//  DaoUserDelegationView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 27.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import SwiftData

struct DaoUserDelegationView: View {
    @StateObject private var dataSource: DaoUserDelegationDataSource
    @Query private var profiles: [UserProfile]

    init(dao: Dao, delegate: User) {
        let dataSource = DaoUserDelegationDataSource(dao: dao, delegate: delegate)
        _dataSource = StateObject(wrappedValue: dataSource)
    }

    private var appUser: User {
        let profile = profiles.first(where: { $0.selected })!
        return profile.user
    }

    var body: some View {
        VStack {
            if dataSource.isLoading {
                ProgressView()
                    .foregroundStyle(Color.textWhite20)
                    .controlSize(.regular)
                Spacer()
            } else if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the delegation information")
            } else if dataSource.userDelegation != nil {
                _DaoUserDelegationView(appUser: appUser, dataSource: dataSource)
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Delegate")
                    .font(.title3Semibold)
                    .foregroundStyle(Color.textWhite)
            }
        }
        .onAppear() {
            // TODO: track
            if dataSource.userDelegation == nil {
                dataSource.refresh()
            }
        }
    }
}

fileprivate struct _DaoUserDelegationView: View {
    let appUser: User
    @ObservedObject private var dataSource: DaoUserDelegationDataSource
    @StateObject private var splitViewModel: UserDelegationSplitViewModel

    @Namespace var namespace
    @Environment(\.dismiss) private var dismiss

    init(appUser: User, dataSource: DaoUserDelegationDataSource) {
        self.appUser = appUser
        _dataSource = ObservedObject(wrappedValue: dataSource)
        let splitViewModel = UserDelegationSplitViewModel(owner: appUser,
                                                          userDelegation: dataSource.userDelegation!,
                                                          delegate: dataSource.delegate)
        _splitViewModel = StateObject(wrappedValue: splitViewModel)
    }

    private var userDelegation: DaoUserDelegation! {
        dataSource.userDelegation
    }

    private var dao: Dao {
        dataSource.dao
    }

    private var delegate: User {
        dataSource.delegate
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 12) {
                HStack {
                    Text("Selected wallet")
                        .font(.bodyRegular)
                        .foregroundStyle(Color.textWhite)

                    Spacer()

                    if let walletImage = WC_Manager.shared.sessionMeta?.walletImage {
                        walletImage
                            .frame(width: Avatar.Size.xs.profileImageSize, height: Avatar.Size.xs.profileImageSize)
                            .scaledToFit()
                            .clipShape(Circle())
                    } else if let walletImageUrl = WC_Manager.shared.sessionMeta?.walletImageUrl {
                        RoundPictureView(image: walletImageUrl, imageSize: Avatar.Size.s.profileImageSize)
                    }

                    IdentityView(user: appUser, size: .xs, font: .bodyRegular, onTap: nil)
                }

                HStack {
                    Text("Voting power")
                        .font(.bodyRegular)
                        .foregroundColor(.textWhite)
                    Spacer()

                    HStack(spacing: 4) {
                        Text(userDelegation.votingPower.power.description)
                        Text(userDelegation.votingPower.symbol)
                    }
                    .font(.bodyRegular)
                    .foregroundColor(.textWhite)
                }

                Divider()
                    .background(Color.secondaryContainer)
                    .padding(.vertical)

                HStack {
                    Text("Delegation scope")
                        .font(.bodyRegular)
                        .foregroundColor(.textWhite)
                    Spacer()
                    HStack {
                        RoundPictureView(image: dao.avatar(size: .xs), imageSize: Avatar.Size.xs.daoImageSize)
                        Text(dao.name)
                            .font(.bodySemibold)
                            .foregroundStyle(Color.textWhite)
                    }
                }

                HStack {
                    Text("Network")
                        .font(.bodyRegular)
                        .foregroundColor(.textWhite)
                    Spacer()
                    HStack {
                        let chains = [userDelegation.chains.gnosis, userDelegation.chains.eth]
                        ForEach(chains) { chain in
                            ZStack {
                                if dataSource.selectedChain == chain {
                                    Text(chain.name)
                                        .foregroundColor(.clear)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color.secondaryContainer)
                                        .cornerRadius(20)
                                        .matchedGeometryEffect(id: "network-background", in: namespace)
                                }

                                Text(chain.name)
                                    .foregroundColor(Color.onSecondaryContainer)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.secondaryContainer, lineWidth: 1)
                                    )
                            }
                            .font(.caption2Semibold)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.5)) {
                                    dataSource.selectedChain = chain
                                }
                            }
                        }
                    }
                }

                UserDelegationSplitVotingPowerView(viewModel: splitViewModel)
                    .padding(.bottom)

                SetDelegateExpirationView()
            }
        }

        HStack {
            HStack {
                SecondaryButton("Cancel") {
                    dismiss()
                }

                PrimaryButton("Confirm") {
                    Haptic.medium()
                    Task {
                        // TODO: api call to assign delegate
                    }
                    dismiss()
                }
            }
        }
    }
}
