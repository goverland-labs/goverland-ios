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
    
    /// Delegates for preparation reguest
    var requestDelegates: [DaoUserDelegationRequest.RequestDelegate] {
        var requestDelegates = [DaoUserDelegationRequest.RequestDelegate]()
        // add all delegates with non-zero percentage
        for (index, delegate) in delegates.enumerated() {
            let powerPercent = Double(round(100 * percentage(for: index)) / 100)
            if powerPercent > 0 {
                requestDelegates.append(
                    DaoUserDelegationRequest.RequestDelegate(address: delegate.user.address.checksum!, 
                                                             resolvedName: delegate.user.resolvedName,
                                                             percentOfDelegated: powerPercent)
                )
            }
        }
        // add owner if it has non-zero percentage
        if ownerReservedPercentage > 0 {
            requestDelegates.append(
                DaoUserDelegationRequest.RequestDelegate(address: owner.address.checksum!,
                                                         resolvedName: owner.resolvedName,
                                                         percentOfDelegated: ownerReservedPercentage)
            )
        }

        return requestDelegates
    }

    init(dao: Dao, owner: User, userDelegation: DaoUserDelegation, delegate: User) {
        self.dao = dao
        self.owner = owner
        self.userDelegation = userDelegation
        self.delegate = delegate
        
        // add to model delegates returned by backend
        for del in userDelegation.delegates {
            if del.user.address == owner.address {
                self.ownerReservedPercentage = Utils.roundedUp(del.powerPercent, decimals: 0)
            } else {
                self.delegates.append((del.user, del.powerRatio))
            }
        }
        
        // add to model selected delegate
        self.addDelegate(self.delegate)

        if self.delegates.count == 0 {
            // when tapped user is the owner and no prior delegates from backend
            self.ownerReservedPercentage = 100
        } else if self.delegates.count == 1 {
            // when tapped user is a new delegate and no prior delegates from backend
            self.ownerReservedPercentage = 0
        }

        self.normalizeDalagates()
    }
    
    func normalizeDalagates() {
        guard let first = delegates.first?.powerRatio else { return }
        
        // Find GCD of all power ratios
        let commonGCD = delegates.reduce(first) { gcd($0, $1.powerRatio) }
        delegates = delegates.map { (user: $0.user, powerRatio: $0.powerRatio / commonGCD) }
    }
    
    private func gcd(_ a: Int, _ b: Int) -> Int {
        return b == 0 ? a : gcd(b, a % b)
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
            if self.ownerReservedPercentage < 100 && self.delegates.count == 1 {
                self.delegates[0].powerRatio = 1
            }
        }
    }

    private func percentage(for index: Int) -> Double {
        guard totalDelegatesAssignedPowerRatios > 0, index < delegates.count else { return 0 }
        let delegateAssignedPower = delegates[index].1
        let availablePowerPercentage = 100.0 - ownerReservedPercentage
        return availablePowerPercentage / Double(totalDelegatesAssignedPowerRatios) * Double(delegateAssignedPower)
    }

    func percentage(for index: Int) -> String {
        let p: Double = percentage(for: index)
        guard p > 0 else { return Utils.numberWithPercent(from: 0) }
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
