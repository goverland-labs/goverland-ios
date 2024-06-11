//
//  Delegate.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 11.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct Delegate: Identifiable, Decodable {
    let id: UUID
    let user: User
    let about: String
    let statement: String
}
