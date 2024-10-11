//
//  MyDelegatorsDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-10-11.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

class MyDelegatorsDataSource: ObservableObject {
    @Published var delegations: [MyDelegations] = []
    
    static let shared = MyDelegatorsDataSource()
    
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
