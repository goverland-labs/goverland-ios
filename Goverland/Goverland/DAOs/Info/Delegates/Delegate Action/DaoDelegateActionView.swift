//
//  DaoDelegateActionView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 27.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

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

struct DaoDelegateActionView: View {
    let dao: Dao
    let delegate: Delegate
    @State private var chosenNetwork: VotingNetworkType = .gnosis
    @Namespace var namespace
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Selected wallet")
                        .font(.bodyRegular)
                        .foregroundColor(.textWhite)
                    
                    Spacer()
                    
                    HStack(spacing: 6) {
                        //TODO: Replace with wallet icons
                        RoundPictureView(image: delegate.user.avatar(size: .xs), imageSize: Avatar.Size.xs.profileImageSize)
                        RoundPictureView(image: delegate.user.avatar(size: .xs), imageSize: Avatar.Size.xs.profileImageSize)
                        RoundPictureView(image: delegate.user.avatar(size: .xs), imageSize: Avatar.Size.xs.profileImageSize)
                        Text(delegate.user.usernameShort)
                    }
                }
                
                HStack {
                    Text("Voting power")
                        .font(.bodyRegular)
                        .foregroundColor(.textWhite)
                    Spacer()
                    // TODO: fix when endpoint is ready
                    Text("43 UNI")
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
            }
            Spacer()
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
    }
}
