//
//  MyDelegatesDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-10-08.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

class MyDelegatesDataSource: ObservableObject {
    @Published var delegations: [MyDelegations] = []
    
    static let shared = MyDelegatesDataSource()
    
    func refresh() {
        let delegates: [MyDelegation] = [MyDelegation.init(id: UUID(), 
                                                           delegate: User.flipside,
                                                           percent_of_delegated: 30,
                                                           expires_at: nil),
                                         MyDelegation.init(id: UUID(), 
                                                           delegate: User.aaveChan,
                                                           percent_of_delegated: 20,
                                                           expires_at: nil),
                                         MyDelegation.init(id: UUID(), 
                                                           delegate: .appUser,
                                                           percent_of_delegated: 50,
                                                           expires_at: nil)]
        let myDelegations: [MyDelegations] = [.init(id: UUID(),
                                                    dao: .aave,
                                                    delegations: delegates),
                                              .init(id: UUID(),
                                                    dao: .gnosis,
                                                    delegations: delegates)]
        
        self.delegations = myDelegations
        
    }
    
    
}

class MyDelegations: Identifiable {
    let id: UUID
    let dao: Dao
    let delegations: [MyDelegation]
    
    init(id: UUID, dao: Dao, delegations: [MyDelegation]) {
        self.id = id
        self.dao = dao
        self.delegations = delegations
    }
}

class MyDelegation: Identifiable {
    let id: UUID
    let delegate: User
    let percent_of_delegated: Float
    let expires_at: Date?
    
    init(id: UUID, delegate: User, percent_of_delegated: Float, expires_at: Date?) {
        self.id = id
        self.delegate = delegate
        self.percent_of_delegated = percent_of_delegated
        self.expires_at = expires_at
    }
}
