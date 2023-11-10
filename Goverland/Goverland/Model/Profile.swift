//
//  Profile.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct Profile: Codable {
    let role: Role
    let accounts: [User]

    enum Role: String, Codable {
        case guest
        case regular
    }
}
