//
//  UserDelegationSplitViewModel.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-08-23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

class UserDelegationSplitViewModel: ObservableObject {
    let owner: User
    let userDelegation: DaoUserDelegation
    
    @Published var ownerPowerReserved: Double = 10.0
    @Published var delegates: [Int: (User, Int)] = [0: (User.aaveChan, 1), 1: (User.flipside, 3)]
    
    @Published var timer: Timer?
    @Published var isTooltipVisible = false
    
    var sortedDelegates: [(key: Int, value: (User, Int))] {
        delegates.sorted { $0.key < $1.key }
    }
    
    var totalAssignedPower: Int {
        delegates.values.reduce(0) { $0 + $1.1 }
    }
    
    init(owner: User, userDelegation: DaoUserDelegation) {
        self.owner = owner
        self.userDelegation = userDelegation
    }
    
    func increaseVotingPower(forIndex index: Int) {
        if ownerPowerReserved == 100 {
            // TODO: warning here
            return
        }
        if let delegate = delegates[index] {
            let newPower = delegate.1 + 1
            delegates[index] = (delegate.0, newPower)
            
        }
    }
    
    func decreaseVotingPower(forIndex index: Int) {
        if let delegate = delegates[index] {
            let newPower = delegate.1 - 1
            if newPower >= 0 {
                delegates[index] = (delegate.0, newPower)
            }
        }
    }
    
    func increaseOwnerVotingPower() {
        if self.ownerPowerReserved < 100 {
            self.ownerPowerReserved += 1
        }
        if self.ownerPowerReserved == 100 {
            resetAllDelegatesVotingPower()
        }
    }
    
    func decreaseOwnerVotingPower() {
        if self.ownerPowerReserved > 0 {
            self.ownerPowerReserved -= 1
        }
    }
    
    func percentage(for index: Int) -> String {
        guard totalAssignedPower > 0, let delegateAssignedPower = delegates[index]?.1 else { return "0" }
        let availablePowerPercantage = 100.0 - ownerPowerReserved
        let p = availablePowerPercantage / Double(totalAssignedPower) * Double(delegateAssignedPower)
        return Utils.numberWithPercent(from: p)
    }
    
    func resetAllDelegatesVotingPower() {
        for key in delegates.keys {
            if var tuple = delegates[key] {
                tuple.1 = 0
                delegates[key] = tuple
            }
        }
        self.ownerPowerReserved = 100
    }
}
    

