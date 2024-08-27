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
    private let userDelegation: DaoUserDelegation
    private let tappedDelegate: User
    
    @Published var ownerPowerReserved: Double = 0.0
    @Published var delegates = [Int: (User, Int)]() // [indexInSplitView: (delegate, powerRatio)]()
    
    @Published var timer: Timer?
    @Published var isTooltipVisible = false
    
    var sortedDelegates: [(key: Int, value: (User, Int))] {
        delegates.sorted { $0.key < $1.key }
    }
    
    var totalAssignedPower: Int {
        delegates.values.reduce(0) { $0 + $1.1 }
    }
    
    init(owner: User, userDelegation: DaoUserDelegation, tappedDelegate: User) {
        self.owner = owner
        self.userDelegation = userDelegation
        self.tappedDelegate = tappedDelegate
       
        // *** case 1: when tapped on self and api [] DONE
//        self.owner = .appOwner
//        self.userDelegation = DaoUserDelegation(dao: .aave,
//                                                votingPower: .init(symbol: "UTI", power: 12.5),
//                                                chains: .testChains,
//                                                delegates: [],
//                                                expirationDate: nil)
//        self.tappedDelegate = User.appOwner
        
        // *** case 2: when tapped on delegate and api [] DONE
//        self.owner = .appOwner
//        self.userDelegation = DaoUserDelegation(dao: .aave,
//                                                votingPower: .init(symbol: "UTI", power: 12.5),
//                                                chains: .testChains,
//                                                delegates: [],
//                                                expirationDate: nil)
//        self.tappedDelegate = User.aaveChan
        
        // *** case 3: when tapped on self and api [some data]
//        self.owner = .appOwner
//        self.userDelegation = DaoUserDelegation(dao: .aave,
//                                                votingPower: .init(symbol: "UTI", power: 12.5),
//                                                chains: .testChains,
//                                                delegates: [.delegateAaveChan, .delegateFlipside],
//                                                expirationDate: nil)
//        self.tappedDelegate = User.appOwner
        
        // *** case 4: when tapped on delegate and api [some data + old delegate]
//        self.owner = .appOwner
//        self.userDelegation = DaoUserDelegation(dao: .aave,
//                                                votingPower: .init(symbol: "UTI", power: 12.5),
//                                                chains: .testChains,
//                                                delegates: [.delegateAaveChan, .delegateFlipside],
//                                                expirationDate: nil)
//        self.tappedDelegate = User.aaveChan
        
        // *** case 5: when tapped on self and api [some data + self]
//        self.owner = .appOwner
//        self.userDelegation = DaoUserDelegation(dao: .aave,
//                                                votingPower: .init(symbol: "UTI", power: 12.5),
//                                                chains: .testChains,
//                                                delegates: [.delegateAaveChan, .init(user: .appOwner,
//                                                                                     powerPercent: 66.6,
//                                                                                     powerRatio: 1)],
//                                                expirationDate: nil)
//        self.tappedDelegate = User.appOwner
        
        // *** case 6: when tapped on delegate and api [some data + self] DONE
//        self.owner = .appOwner
//        self.userDelegation = DaoUserDelegation(dao: .aave,
//                                                votingPower: .init(symbol: "UTI", power: 12.5),
//                                                chains: .testChains,
//                                                delegates: [.delegateAaveChan, .init(user: .appOwner,
//                                                                                     powerPercent: 66.6,
//                                                                                     powerRatio: 1)],
//                                                expirationDate: nil)
//        self.tappedDelegate = User.aaveChan
        
        // *** case 7: when tapped on new delegate and api [some data + self]
//        self.owner = .appOwner
//        self.userDelegation = DaoUserDelegation(dao: .aave,
//                                                votingPower: .init(symbol: "UTI", power: 12.5),
//                                                chains: .testChains,
//                                                delegates: [.delegateAaveChan, .init(user: .appOwner,
//                                                                                     powerPercent: 66.6,
//                                                                                     powerRatio: 1)],
//                                                expirationDate: nil)
//        self.tappedDelegate = User.flipside
        
        // *** case 8: when tapped on new delegate and api [some data + self]
//        self.owner = .appOwner
//        self.userDelegation = DaoUserDelegation(dao: .aave,
//                                                votingPower: .init(symbol: "UTI", power: 12.5),
//                                                chains: .testChains,
//                                                delegates: [.delegateAaveChan,
//                                                            .init(user: .appOwner,
//                                                                  powerPercent: 66.6,
//                                                                  powerRatio: 1),
//                                                            .delegateFlipside,
//                                                            .delegateTest],
//                                                expirationDate: nil)
//        self.tappedDelegate = User.flipside
        
        for (index, del) in userDelegation.delegates.enumerated() {
            if del.user.address == owner.address {
                self.ownerPowerReserved = del.powerPercent
            } else {
                self.delegates[index] = (del.user, del.powerRatio)
            }
        }
        
        // Shift existing elements to insert the new delegate at the beginning
        if !delegates.contains(where: { $0.value.0 == tappedDelegate }) && tappedDelegate != owner {
            for index in (0..<delegates.count).reversed() {
                delegates[index + 1] = delegates[index]
            }
            delegates[0] = (tappedDelegate, 1)
        }
        
        // when tapped user is the owner and no prior delegates from api
        if self.delegates.count == 0 {
            self.ownerPowerReserved = 100
        } else if self.delegates.count == 1 && delegates.first?.value.1 == 0 {
            self.ownerPowerReserved = 0
        }
        
        // Normalized dictionary since some indexes might be missing when the owner is sent from the backend
        delegates = Dictionary(uniqueKeysWithValues: delegates.values.enumerated().map { index, element in
            (index, element)
        })
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
    
    func divideEquallyVotingPower() {
        if ownerPowerReserved < 100 {
            delegates = delegates.mapValues { (user, _) in (user, 1) }
        }
    }
}
