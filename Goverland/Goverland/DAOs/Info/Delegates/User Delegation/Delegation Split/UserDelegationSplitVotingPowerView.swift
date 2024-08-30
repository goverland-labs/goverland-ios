//
//  UserDelegationSplitVotingPowerView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-07-11.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct UserDelegationSplitVotingPowerView: View {
    @StateObject private var viewModel: UserDelegationSplitViewModel
    @State private var isTooltipVisible = false
    
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    
    init(owner: User, userDelegation: DaoUserDelegation, tappedDelegate: User) {
        let viewModel = UserDelegationSplitViewModel(owner: owner, userDelegation: userDelegation, tappedDelegate: tappedDelegate)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            if viewModel.delegates.count > 0 {
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
                    
                    if viewModel.delegates.count > 1 {
                        HStack(spacing: 3) {
                            Image(systemName: "divide")
                            Text("Divide equally")
                                .underline()
                        }
                        .font(.footnoteRegular)
                        .foregroundColor(viewModel.ownerPowerReserved == 100 ? .textWhite20 : .textWhite60)
                        .onTapGesture {
                            viewModel.divideEquallyVotingPower()
                        }
                    }
                }
                ForEach(Array(viewModel.delegates.enumerated()), id: \.offset) { index, delegate in
                    let (user, powerRatio) = delegate
                    HStack {
                        IdentityView(user: delegate.0, onTap: nil)
                        Spacer()
                        HStack(spacing: 0) {
                            CounterControlView(systemImageName: "minus",
                                               backgroundColor: delegate.1 == 0 ? Color.clear : Color.secondaryContainer) {
                                viewModel.decreaseVotingPower(forIndex: index)
                            }
                            Text(String(delegate.1))
                                .frame(width: 20)
                            CounterControlView(systemImageName: "plus",
                                               backgroundColor: delegate.1 == 0 ? Color.clear : Color.secondaryContainer) {
                                viewModel.increaseVotingPower(forIndex: index)
                            }
                            Text(viewModel.percentage(for: index))
                                .frame(width: 55)
                        }
                        .font(.footnoteSemibold)
                        .foregroundColor(.onSecondaryContainer)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
                    .padding(.horizontal)
                    .background(delegate.1 == 0 ? Color.clear : Color.secondaryContainer)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.secondaryContainer, lineWidth: 1)
                    )
                }
            }
            
            HStack {
                NavigationLink(destination: DelegatesFullListView(dao: viewModel.userDelegation.dao).environmentObject(activeSheetManager)) {
                    HStack(spacing: 3) {
                        Image(systemName: "plus")
                        Text("Add delegate")
                            .underline()
                    }
                    .font(.footnoteRegular)
                    .foregroundColor(.textWhite60)
                }
                
                Spacer()
                
                if viewModel.delegates.count > 1 {
                    HStack(spacing: 3) {
                        Image(systemName: "delete.right")
                        Text("Clear all delegations")
                            .underline()
                    }
                    .font(.footnoteRegular)
                    .foregroundColor(viewModel.ownerPowerReserved == 100 ? .textWhite20 : .textWhite60)
                    .onTapGesture {
                        viewModel.resetAllDelegatesVotingPower()
                    }
                }
            }
            .padding(.top, 10)

            
            HStack {
                 HStack {
                     Text(viewModel.delegates.count > 0 ? "Keep for yourself" : "Delegate to yourself")
                        .font(.bodyRegular)
                        .foregroundColor(.textWhite)
                    
                    Image(systemName: "questionmark.circle")
                        .foregroundStyle(Color.textWhite40)
                        .padding(.trailing)
                        .tooltip($viewModel.isTooltipVisible, side: .topRight, width: 200) {
                            Text("Keep for yourself")
                                .foregroundStyle(Color.textWhite60)
                                .font(.сaptionRegular)
                        }
                        .onTapGesture() {
                            withAnimation {
                                viewModel.isTooltipVisible.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                    if viewModel.isTooltipVisible {
                                        viewModel.isTooltipVisible.toggle()
                                    }
                                }
                            }
                        }
                }
                Spacer()
            }
            .padding(.vertical)
            
            HStack {
                IdentityView(user: viewModel.owner, onTap: nil)
                Spacer()
                HStack(spacing: 0) {
                    CounterControlView(systemImageName: "minus",
                                       backgroundColor: viewModel.ownerPowerReserved == 0 ? Color.clear : Color.secondaryContainer,
                                       longPressTimeInterval: 0.05) {
                        viewModel.decreaseOwnerVotingPower()
                    }
                    Text(Utils.numberWithPercent(from: viewModel.ownerPowerReserved))
                        .frame(width: 45)
                    CounterControlView(systemImageName: "plus",
                                       backgroundColor: viewModel.ownerPowerReserved == 0 ? Color.clear : Color.secondaryContainer,
                                       longPressTimeInterval: 0.05) {
                        viewModel.increaseOwnerVotingPower()
                    }
                }
                .font(.footnoteSemibold)
                .foregroundColor(.onSecondaryContainer)
            }
            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
            .padding(.horizontal)
            .background(viewModel.ownerPowerReserved == 0 ? Color.clear : Color.secondaryContainer)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.secondaryContainer, lineWidth: 1)
            )
            
        }
    }
}
