//
//  VoteTypedData.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 14.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct VoteTypedData: Decodable {
    let typedData: String

    enum CodingKeys: String, CodingKey {
        case typedData = "typed_data"
    }
}
