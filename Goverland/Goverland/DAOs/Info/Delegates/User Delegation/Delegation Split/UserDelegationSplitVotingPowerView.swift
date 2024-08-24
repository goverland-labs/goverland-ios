//
//  UserDelegationSplitVotingPowerView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-07-11.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct UserDelegationSplitVotingPowerView: View {
    private let owner: User = .aaveChan
    @State private var ownerPowerReserved: Double = 10.0
    @State private var delegates: [Int: (User, Int)] = [0: (User.aaveChan, 1),
                                                           1: (User.flipside, 3)]
    
    @State private var timer: Timer?
    @State private var isTooltipVisible = false
    
    private var sortedDelegates: [(key: Int, value: (User, Int))] {
        delegates.sorted { $0.key < $1.key }
    }
    private var totalAssignedPower: Int {
        delegates.values.reduce(0) { $0 + $1.1 }
    }
    
    var body: some View {
        VStack {
            ForEach(Array(sortedDelegates.enumerated()), id: \.1.key) { (index, element) in
                HStack {
                    IdentityView(user: element.value.0, onTap: nil)
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        CounterControlView(systemImageName: "minus",
                                           backgroundColor: element.value.1 == 0 ? Color.clear : Color.secondaryContainer) {
                            decreaseVotingPower(forIndex: index)
                        }
                        
                        Text(String(element.value.1))
                            .frame(width: 20)
                        
                        CounterControlView(systemImageName: "plus",
                                           backgroundColor: element.value.1 == 0 ? Color.clear : Color.secondaryContainer) {
                            increaseVotingPower(forIndex: index)
                        }
                        
                        Text(percentage(for: index))
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
                        .tooltip($isTooltipVisible, side: .topRight, width: 200) {
                            Text("Keep for yourself")
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
                
                HStack {
                    Image(systemName: "delete.right")
                    Text("Clear all delegations")
                }
                .font(.footnoteRegular)
                .foregroundColor(.textWhite60)
                .onTapGesture {
                    resetAllDelegatesVotingPower()
                }
            }
            .padding(.vertical)
            
            HStack {
                IdentityView(user: owner, onTap: nil)
                
                Spacer()
                
                HStack(spacing: 0) {
                    CounterControlView(systemImageName: "minus",
                                       backgroundColor: ownerPowerReserved == 0 ? Color.clear : Color.secondaryContainer,
                                       longPressTimeInterval: 0.05) {
                        decreaseOwnerVotingPower()
                    }
                    
                    Text(Utils.numberWithPercent(from: ownerPowerReserved))
                        .frame(width: 40)
                    
                    CounterControlView(systemImageName: "plus",
                                       backgroundColor: ownerPowerReserved == 0 ? Color.clear : Color.secondaryContainer,
                                       longPressTimeInterval: 0.05) {
                        increaseOwnerVotingPower()
                    }
                }
                .font(.footnoteSemibold)
                .foregroundColor(.onSecondaryContainer)
            }
            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
            .padding(.horizontal)
            .background(ownerPowerReserved == 0 ? Color.clear : Color.secondaryContainer)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.secondaryContainer, lineWidth: 1)
            )
            
        }
    }
    
    private func increaseVotingPower(forIndex index: Int) {
        if ownerPowerReserved == 100 {
            // TODO: warning here
            return
        }
        if let delegate = delegates[index] {
            let newPower = delegate.1 + 1
            delegates[index] = (delegate.0, newPower)
            
        }
    }
    
    private func decreaseVotingPower(forIndex index: Int) {
        if let delegate = delegates[index] {
            let newPower = delegate.1 - 1
            if newPower >= 0 {
                delegates[index] = (delegate.0, newPower)
            }
        }
    }
    
    private func increaseOwnerVotingPower() {
        if self.ownerPowerReserved < 100 {
            self.ownerPowerReserved += 1
        }
        if self.ownerPowerReserved == 100 {
            resetAllDelegatesVotingPower()
        }
    }
    
    private func decreaseOwnerVotingPower() {
        if self.ownerPowerReserved > 0 {
            self.ownerPowerReserved -= 1
        }
    }
    
    private func percentage(for index: Int) -> String {
        guard totalAssignedPower > 0, let delegateAssignedPower = delegates[index]?.1 else { return "0" }
        let availablePowerPercantage = 100.0 - ownerPowerReserved
        let p = availablePowerPercantage / Double(totalAssignedPower) * Double(delegateAssignedPower)
        return Utils.numberWithPercent(from: p)
    }
    
    private func resetAllDelegatesVotingPower() {
        for key in delegates.keys {
            if var tuple = delegates[key] {
                tuple.1 = 0
                delegates[key] = tuple
            }
        }
        self.ownerPowerReserved = 100
    }
}
