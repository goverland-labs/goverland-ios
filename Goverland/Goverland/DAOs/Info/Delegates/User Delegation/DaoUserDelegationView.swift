//
//  DaoUserDelegationView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 27.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import SwiftData

enum VotingNetworkType: Int, Identifiable {
    var id: Int { self.rawValue }

    case gnosis = 0
    case etherium

    static var allNetwork: [VotingNetworkType] {
        [.gnosis, .etherium]
    }

    func localizedName() -> String {
        switch self {
        case .gnosis:
            return "Gnosis Chain"
        case .etherium:
            return "Etherium"
        }
    }
}

struct DaoUserDelegationView: View {
    let dao: Dao
    let delegate: Delegate
    
    @StateObject private var dataSource: DaoUserDelegationDataSource
    @State private var chosenNetwork: VotingNetworkType = .gnosis
    @Query private var profiles: [UserProfile]
    @Namespace var namespace
    @State private var isTooltipVisible = false
    @Environment(\.dismiss) private var dismiss
    
    var userDelegation: DaoUserDelegation? {
        return dataSource.userDelegation
    }
    
    private var user: User {
        let profile = profiles.first(where: { $0.selected })!
        return profile.user
    }
    
    init(dao: Dao, delegate: Delegate) {
        let dataSource = DaoUserDelegationDataSource(dao: dao)
        _dataSource = StateObject(wrappedValue: dataSource)
        self.dao = dao
        self.delegate = delegate
    }
    
    var body: some View {
        VStack {
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

                        IdentityView(user: user, size: .xs, font: .bodyRegular, onTap: nil)
                    }
                    
                    HStack {
                        Text("Voting power")
                            .font(.bodyRegular)
                            .foregroundColor(.textWhite)
                        Spacer()
                        
                        if let userDelegationVotingPower = userDelegation?.votingPower {
                            HStack(spacing: 4) {
                                Text(userDelegationVotingPower.power.description)
                                Text(userDelegationVotingPower.symbol)
                            }
                            .font(.bodyRegular)
                            .foregroundColor(.textWhite)
                        }
                        
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
                            ForEach(VotingNetworkType.allNetwork) { network in
                                ZStack {
                                    if chosenNetwork == network {
                                        Text(network.localizedName())
                                            .foregroundColor(.clear)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(Color.secondaryContainer)
                                            .cornerRadius(20)
                                            .matchedGeometryEffect(id: "network-background", in: namespace)
                                    }
                                    
                                    Text(network.localizedName())
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
                                        chosenNetwork = network
                                    }
                                }
                            }
                        }
                    }
                    
                    HStack {
                        HStack {
                            Text("Delegate to")
                                .font(.bodyRegular)
                                .foregroundColor(.textWhite)
                            
                            Image(systemName: "questionmark.circle")
                                .foregroundStyle(Color.textWhite40)
                                .padding(.trailing)
                                .tooltip($isTooltipVisible, side: .topRight, width: 200) {
                                    Text("Tooltip text goes here")
                                        .foregroundStyle(Color.textWhite60)
                                        .font(.сaptionRegular)
                                }
                                .onTapGesture() {
                                    withAnimation {
                                        isTooltipVisible.toggle()
                                        // Show tooltip for 5 sec only
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                            if isTooltipVisible {
                                                isTooltipVisible.toggle()
                                            }
                                        }
                                    }
                                }
                        }
                        Spacer()
                    }
                    
                    if let userDelegation {
                        UserDelegationSplitVotingPowerView()
                            .padding(.bottom)
                    }

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
            if dataSource.userDelegation == nil {
                dataSource.refresh()
            }
        }
    }
}
