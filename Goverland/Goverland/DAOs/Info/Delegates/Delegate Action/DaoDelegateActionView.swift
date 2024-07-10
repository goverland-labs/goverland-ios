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
    @State private var isTooltipVisible = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 12) {
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
                    
                    HStack {
                        HStack {
                            Text("Delegate to")
                                .font(.bodyRegular)
                                .foregroundColor(.textWhite)
                            
                            Image(systemName: "questionmark.circle")
                                .foregroundStyle(Color.textWhite40)
                                .padding(.trailing)
                                .tooltip($isTooltipVisible, side: .bottomRight, width: 200) {
                                    Text("Tooltip text goes here")
                                        .foregroundStyle(Color.textWhite60)
                                        .font(.сaptionRegular)
                                }
                                .onTapGesture() {
                                    withAnimation {
                                        isTooltipVisible.toggle()
                                        // Shoe tooltip for 5 sec only
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
                    
                    HStack {
                        DelegateVotingPowerChoseView()
                    }
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
    }
}


fileprivate struct DelegateVotingPowerChoseView: View {
    
    private let votingPower: Double = 43.0
    @State private var delegates: [Int: (User, Double)] = [0: (User.aaveChan, 11.0),
                                                    1: (User.flipside, 32.0)]
    private var sortedDelegates: [(key: Int, value: (User, Double))] {
        delegates.sorted { $0.key < $1.key }
    }
    
    
    var body: some View {
        VStack {
            ForEach(Array(sortedDelegates.enumerated()), id: \.1.key) { (index, element) in
                HStack {
                    IdentityView(user: element.value.0, onTap: nil)
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        Button(action: {
                            decreaseVotingPower(forIndex: index)
                        }) {
                            Image(systemName: "minus")
                                .frame(width: 40)
                                .padding(.vertical)
                        }
                        
                        Text(String(format: "%.0f", element.value.1))
                            .frame(width: 20)
                        
                        Button(action: {
                            increaseVotingPower(forIndex: index)
                        }) {
                            Image(systemName: "plus")
                                .frame(width: 40)
                                .padding(.vertical)
                        }
                        
                        Text("30%")
                            .frame(width: 55)
                    }
                    .font(.footnoteSemibold)
                    .foregroundColor(.onSecondaryContainer)
                }
                .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
                .padding(.horizontal)
                .background(true ? Color.secondaryContainer : Color.clear)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.secondaryContainer, lineWidth: 1)
                )
            }
        }
    }
    
    private func increaseVotingPower(forIndex index: Int) {
        if let delegate = delegates[index] {
            let newPower = delegate.1 + 1.0
            let totalPower = getTotalVotingPower()
            
            if totalPower + (newPower - delegate.1) <= votingPower {
                delegates[index] = (delegate.0, newPower)
            } else {
                // TODO: Handle exceeding limit (show an alert)
                print("Exceeds total voting power limit!")
            }
        }
    }
    
    private func decreaseVotingPower(forIndex index: Int) {
        if let delegate = delegates[index] {
            let newPower = delegate.1 - 1.0
            
            if newPower >= 0 {
                delegates[index] = (delegate.0, newPower)
            }
        }
    }
    
    private func getTotalVotingPower() -> Double {
        return delegates.reduce(0.0) { $0 + $1.value.1 }
    }
}
