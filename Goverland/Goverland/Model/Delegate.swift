//
//  Delegate.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 11.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct Delegate: Identifiable, Decodable, Equatable {
    let id: UUID
    let user: User
    let about: String
    let statement: String
    let userDelegated: Bool?
    let delegators: Int
    let votes: Int
    let proposalsCreated: Int
}
