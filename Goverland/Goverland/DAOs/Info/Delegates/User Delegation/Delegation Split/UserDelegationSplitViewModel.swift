//
//  UserDelegationSplitViewModel.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-08-23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

class UserDelegationSplitViewModel: ObservableObject {
    let dao: Dao
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
    
    var isConfirmEnabled: Bool {
        !(self.totalDelegatesAssignedPowerRatios == 0 && self.ownerReservedPercentage < 100)
    }
    
    init(dao: Dao, owner: User, userDelegation: DaoUserDelegation, delegate: User) {
        self.dao = dao
        self.owner = owner
        self.userDelegation = userDelegation
        self.delegate = delegate
        
        // add to model delegates returned by backend
        for del in userDelegation.delegates {
            if del.user.address == owner.address {
                self.ownerReservedPercentage = del.powerPercent
            } else {
                self.delegates.append((del.user, del.powerRatio))
            }
        }
        
        // add to model selected delegate
        self.addDelegate(self.delegate)

        if self.delegates.count == 0 {
            // when tapped user is the owner and no prior delegates from backend
            self.ownerReservedPercentage = 100
        } else if self.delegates.count == 1 && delegates.first?.powerRatio == 0 {
            // when tapped user is a new delegate and no prior delegates from backend
            self.ownerReservedPercentage = 0
        }

        // TODO: add powerRatio normalization. E.g. if we have now two delegates with 3/3 and owner 40%
    }
    
    func addDelegate(_ delegate: User) {
        guard !delegates.contains(where: { $0.0 == delegate }) && delegate != owner else { return }
        delegates.insert((user: delegate, powerRatio: delegates.isEmpty ? 1 : 0), at: 0)
    }
    
    func increaseVotingPower(forIndex index: Int) {
        guard index < delegates.count else { return }
        if ownerReservedPercentage == 100 {
            // TODO: add an alert with warning here
            return
        }
        let delegate = delegates[index]
        let newPowerRatio = delegate.powerRatio + 1
        delegates[index] = (delegate.0, newPowerRatio)
    }
    
    func decreaseVotingPower(forIndex index: Int) {
        guard index < delegates.count else { return }
        let delegate = delegates[index]
        let newPowerRatio = delegate.1 - 1
        if newPowerRatio >= 0 {
            delegates[index] = (delegate.0, newPowerRatio)
        }
    }
    
    func increaseOwnerVotingPower() {
        if ownerReservedPercentage < 100 {
            ownerReservedPercentage = min(round(ownerReservedPercentage + 1), 100)
        }

        if ownerReservedPercentage == 100 {
            setAllDelegateWeights(to: 0)
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
        setAllDelegateWeights(to: 0)
        ownerReservedPercentage = 100
    }
    
    func divideEquallyVotingPower() {
        if ownerReservedPercentage < 100 {
            setAllDelegateWeights(to: 1)
        }
    }

    private func setAllDelegateWeights(to value: Int) {
        delegates = delegates.map { (user, _) in (user, value) }
    }
}