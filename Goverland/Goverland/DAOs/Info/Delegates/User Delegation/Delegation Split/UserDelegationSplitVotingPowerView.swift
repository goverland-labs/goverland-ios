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
    
    init(owner: User, userDelegation: DaoUserDelegation, tappedDelegate: User) {
        let viewModel = UserDelegationSplitViewModel(owner: owner, userDelegation: userDelegation, tappedDelegate: tappedDelegate)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            ForEach(Array(viewModel.sortedDelegates.enumerated()), id: \.1.key) { (index, element) in
                HStack {
                    IdentityView(user: element.value.0, onTap: nil)
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        CounterControlView(systemImageName: "minus",
                                           backgroundColor: element.value.1 == 0 ? Color.clear : Color.secondaryContainer) {
                            viewModel.decreaseVotingPower(forIndex: index)
                        }
                        
                        Text(String(element.value.1))
                            .frame(width: 20)
                        
                        CounterControlView(systemImageName: "plus",
                                           backgroundColor: element.value.1 == 0 ? Color.clear : Color.secondaryContainer) {
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
                .background(element.value.1 == 0 ? Color.clear : Color.secondaryContainer)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.secondaryContainer, lineWidth: 1)
                )
            }
            
            HStack {
                 HStack {
                    Text("Keep for yourself")
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
                                // Show tooltip for 5 sec only
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                    if viewModel.isTooltipVisible {
                                        viewModel.isTooltipVisible.toggle()
                                    }
                                }
                            }
                        }
                }
                Spacer()
                
                HStack {
                    Image(systemName: "delete.right")
                    Text("Clear all delegations")
                }
                .font(.footnoteRegular)
                .foregroundColor(.textWhite60)
                .onTapGesture {
                    viewModel.resetAllDelegatesVotingPower()
                }
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
                        .frame(width: 40)
                    
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
