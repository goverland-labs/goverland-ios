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
    
    @Published var ownerReservedPercentage: Double = 0.0
    @Published var delegates = [(user: User, powerRatio: Int)]()

    @Published var timer: Timer?
    @Published var isTooltipVisible = false
    
    var totalDelegatesAssignedPowerRatios: Int {
        delegates.reduce(0) { $0 + $1.powerRatio }
    }
    
    var isConfirmEnable: Bool {
        !(self.totalDelegatesAssignedPowerRatios == 0 && self.ownerReservedPercentage < 100)
    }
    
    init(owner: User, userDelegation: DaoUserDelegation, delegate: User) {
        self.owner = owner
        self.userDelegation = userDelegation
        self.delegate = delegate
        
        for del in userDelegation.delegates {
            if del.user.address == owner.address {
                self.ownerReservedPercentage = del.powerPercent
            } else {
                self.delegates.append((del.user, del.powerRatio))
            }
        }
        
        self.addDelegate(self.delegate)
        
        // when tapped user is the owner and no prior delegates from api
        if self.delegates.count == 0 {
            self.ownerReservedPercentage = 100
        } else if self.delegates.count == 1 && delegates.first?.1 == 0 {
            self.ownerReservedPercentage = 0
        }
    }
    
    func addDelegate(_ delegate: User) {
        if !delegates.contains(where: { $0.0 == delegate }) && delegate != owner {
            // Shift existing elements to insert the new delegate at the beginning
            var tempDelegates = [(User, Int)]()
            tempDelegates.append((delegate, delegates.isEmpty ? 1 : 0))
            tempDelegates.append(contentsOf: delegates)
            delegates = tempDelegates
        }
    }
    
    func increaseVotingPower(forIndex index: Int) {
        if ownerReservedPercentage == 100 {
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
        if self.ownerReservedPercentage < 100 {
            self.ownerReservedPercentage = min(round(self.ownerReservedPercentage + 1), 100)
        }
        if self.ownerReservedPercentage == 100 {
            resetAllDelegatesVotingPower()
        }
    }
    
    func decreaseOwnerVotingPower() {
        if self.ownerReservedPercentage > 0 {
            self.ownerReservedPercentage = max(round(self.ownerReservedPercentage - 1), 0)
        }
    }

    func percentage(for index: Int) -> Double {
        guard totalDelegatesAssignedPowerRatios > 0, index < delegates.count else { return 0 }
        let delegateAssignedPower = delegates[index].1
        let availablePowerPercentage = 100.0 - ownerReservedPercentage
        return availablePowerPercentage / Double(totalDelegatesAssignedPowerRatios) * Double(delegateAssignedPower)
    }

    func percentage(for index: Int) -> String {
        let p: Double = percentage(for: index)
        guard p > 0 else { return "0" }
        return Utils.numberWithPercent(from: p)
    }
    
    func resetAllDelegatesVotingPower() {
        if self.ownerReservedPercentage == 100 {
            return
        }
        for index in delegates.indices {
            var tuple = delegates[index]
            tuple.1 = 0
            delegates[index] = tuple
        }
        self.ownerReservedPercentage = 100
    }
    
    func divideEquallyVotingPower() {
        if ownerReservedPercentage < 100 {
            delegates = delegates.map { (user, _) in (user, 1) }
        }
    }
}
