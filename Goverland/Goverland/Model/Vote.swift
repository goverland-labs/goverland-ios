//
//  Vote.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-06.
//

import SwiftUI

// TODO: this is a stab
struct Vote: Identifiable, Decodable, Equatable {
    let id: UUID
    let name: String
    let image: URL?
    let message: String?
    
    init(id: UUID,
         name: String,
         image: URL?,
         message: String?) {
        self.id = id
        self.name = name
        self.image = image
        self.message = message
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.image = try container.decodeIfPresent(URL.self, forKey: .image)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
    }
}
