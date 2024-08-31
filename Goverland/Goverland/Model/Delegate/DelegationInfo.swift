//
//  DelegationInfo.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-08-20.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct DelegationInfo: Decodable, Equatable {
    let percentDelegated: Double
    
    enum CodingKeys: String, CodingKey {
        case percentDelegated = "percent_of_delegated"
    }
}
