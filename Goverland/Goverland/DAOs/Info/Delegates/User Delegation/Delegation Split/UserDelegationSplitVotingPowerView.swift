//
//  UserDelegationSplitVotingPowerView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-07-11.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct UserDelegationSplitVotingPowerView: View {
    @ObservedObject var viewModel: UserDelegationSplitViewModel
    
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    @State private var showAddDelegate = false
    
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
                            .onTapGesture() {
                                showInfoAlert("In \(viewModel.dao.name), you can delegate your voting power to multiple delegates simultaneously while retaining some for yourself. Only the delegated voting power is eligible to participate in governance.")
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
                        .foregroundColor(viewModel.ownerReservedPercentage == 100 ? .textWhite20 : .textWhite60)
                        .onTapGesture {
                            viewModel.divideEquallyVotingPower()
                        }
                    }
                }
                ForEach(Array(viewModel.delegates.enumerated()), id: \.offset) { index, delegate in
                    HStack {
                        IdentityView(user: delegate.user, onTap: nil)
                        Spacer()
                        HStack(spacing: 0) {
                            if viewModel.delegates.count > 1 {
                                CounterControlView(systemImageName: "minus",
                                                   backgroundColor: delegate.powerRatio == 0 ? Color.clear : Color.secondaryContainer) {
                                    viewModel.decreaseVotingPower(forIndex: index)
                                }

                                Text(String(delegate.powerRatio))
                                    .frame(width: 20)

                                CounterControlView(systemImageName: "plus",
                                                   backgroundColor: delegate.powerRatio == 0 ? Color.clear : Color.secondaryContainer) {
                                    viewModel.increaseVotingPower(forIndex: index)
                                }
                            }

                            Text(viewModel.percentage(for: index))
                                .frame(width: 55)
                        }
                        .font(.footnoteSemibold)
                        .foregroundColor(.onSecondaryContainer)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
                    .padding(.horizontal)
                    .background(delegate.powerRatio == 0 ? Color.clear : Color.secondaryContainer)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.secondaryContainer, lineWidth: 1)
                    )
                }
            }
            
            HStack {
                HStack(spacing: 3) {
                    Image(systemName: "plus")
                    Text("Add delegate")
                        .underline()
                }
                .font(.footnoteRegular)
                .foregroundColor(.textWhite60)
                .onTapGesture {
                    showAddDelegate = true
                }

                Spacer()
                
                if viewModel.delegates.count > 1 {
                    HStack(spacing: 3) {
                        Image(systemName: "delete.right")
                        Text("Clear all delegations")
                            .underline()
                    }
                    .font(.footnoteRegular)
                    .foregroundColor(viewModel.ownerReservedPercentage == 100 ? .textWhite20 : .textWhite60)
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
                        .onTapGesture() {
                            showInfoAlert("You can keep all or part of your voting power for yourself, distributing the rest among one or more delegates.")
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
                                       backgroundColor: viewModel.ownerReservedPercentage == 0 ? Color.clear : Color.secondaryContainer,
                                       longPressTimeInterval: 0.05) {
                        viewModel.decreaseOwnerVotingPower()
                    }
                    Text(Utils.numberWithPercent(from: viewModel.ownerReservedPercentage))
                        .frame(width: 45)
                    CounterControlView(systemImageName: "plus",
                                       backgroundColor: viewModel.ownerReservedPercentage == 0 ? Color.clear : Color.secondaryContainer,
                                       longPressTimeInterval: 0.05) {
                        viewModel.increaseOwnerVotingPower()
                    }
                }
                .font(.footnoteSemibold)
                .foregroundColor(.onSecondaryContainer)
            }
            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
            .padding(.horizontal)
            .background(viewModel.ownerReservedPercentage == 0 ? Color.clear : Color.secondaryContainer)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.secondaryContainer, lineWidth: 1)
            )
        }
        .sheet(isPresented: $showAddDelegate) {
            NavigationStack {
                DelegatesFullListView(dao: viewModel.userDelegation.dao, action: .add(onAdd: { delegate in
                    viewModel.addDelegate(delegate.user)
                }))
                .navigationBarBackButtonHidden(true)
            }
            .overlay {
                ToastView()
                    .environmentObject(activeSheetManager)
            }
        }
    }
}
