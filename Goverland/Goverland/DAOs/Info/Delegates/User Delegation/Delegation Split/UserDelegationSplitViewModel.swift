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
    
    init(owner: User, userDelegation: DaoUserDelegation) {
        self.owner = owner
        self.userDelegation = userDelegation
    }
    
    
}
    

