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
    private let delegate: User
    
    @Published var ownerPowerReserved: Double = 0.0
    @Published var delegates = [(user: User, powerRatio: Int)]()

    @Published var timer: Timer?
    @Published var isTooltipVisible = false
    
    var totalAssignedPower: Int {
        delegates.reduce(0) { $0 + $1.1 }
    }
    
    init(owner: User, userDelegation: DaoUserDelegation, delegate: User) {
        self.owner = owner
        self.userDelegation = userDelegation
        self.delegate = delegate
        
        for del in userDelegation.delegates {
            if del.user.address == owner.address {
                self.ownerPowerReserved = del.powerPercent
            } else {
                self.delegates.append((del.user, del.powerRatio))
            }
        }
        
        // Shift existing elements to insert the new delegate at the beginning
        if !delegates.contains(where: { $0.0 == delegate }) && delegate != owner {
            var tempDelegates = [(User, Int)]()
            tempDelegates.append((delegate, delegates.isEmpty ? 1 : 0))
            tempDelegates.append(contentsOf: delegates)
            delegates = tempDelegates
        }
        
        // when tapped user is the owner and no prior delegates from api
        if self.delegates.count == 0 {
            self.ownerPowerReserved = 100
        } else if self.delegates.count == 1 && delegates.first?.1 == 0 {
            self.ownerPowerReserved = 0
        }
    }
    
    func increaseVotingPower(forIndex index: Int) {
        if ownerPowerReserved == 100 {
            // TODO: warning here
            return
        }
        if index < delegates.count {
            let delegate = delegates[index]
            let newPower = delegate.1 + 1
            delegates[index] = (delegate.0, newPower)
        }
    }
    
    func decreaseVotingPower(forIndex index: Int) {
        if index < delegates.count {
            let delegate = delegates[index]
            let newPower = delegate.1 - 1
            if newPower >= 0 {
                delegates[index] = (delegate.0, newPower)
            }
        }
    }
    
    func increaseOwnerVotingPower() {
        if self.ownerPowerReserved < 100 {
            self.ownerPowerReserved = min(round(self.ownerPowerReserved + 1), 100)
        }
        if self.ownerPowerReserved == 100 {
            resetAllDelegatesVotingPower()
        }
    }
    
    func decreaseOwnerVotingPower() {
        if self.ownerPowerReserved > 0 {
            self.ownerPowerReserved = max(round(self.ownerPowerReserved - 1), 0)
        }
    }
    
    func percentage(for index: Int) -> String {
        guard totalAssignedPower > 0, index < delegates.count else { return "0" }
        let delegateAssignedPower = delegates[index].1
        let availablePowerPercentage = 100.0 - ownerPowerReserved
        let p = availablePowerPercentage / Double(totalAssignedPower) * Double(delegateAssignedPower)
        return Utils.numberWithPercent(from: p)
    }
    
    func resetAllDelegatesVotingPower() {
        if self.ownerPowerReserved == 100 {
            return
        }
        for index in delegates.indices {
            var tuple = delegates[index]
            tuple.1 = 0
            delegates[index] = tuple
        }
        self.ownerPowerReserved = 100
    }
    
    func divideEquallyVotingPower() {
        if ownerPowerReserved < 100 {
            delegates = delegates.map { (user, _) in (user, 1) }
        }
    }
}
