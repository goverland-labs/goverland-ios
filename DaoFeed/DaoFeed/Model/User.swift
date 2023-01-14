//
//  User.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2023-01-06.
//

import SwiftUI

struct User: Decodable {
    
    let address: String
    let ensName: String?
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case address
        case ensName
        case image
    }
    
    init(address: String, image: String, name: String?) {
        self.address = address
        self.ensName = name
        self.image = image
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address = try container.decode(String.self, forKey: .address)
        self.ensName = try container.decodeIfPresent(String.self, forKey: .ensName)
        self.image = try container.decode(String.self, forKey: .image)
    }
}
