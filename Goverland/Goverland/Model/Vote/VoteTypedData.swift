//
//  VoteTypedData.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 14.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct VoteTypedData: Decodable {
    let id: UUID
    let typedData: String

    enum CodingKeys: String, CodingKey {
        case id
        case typedData = "typed_data"
    }
}
