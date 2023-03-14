//
//  User.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-06.
//

import SwiftUI

struct User: Decodable {
    
    let address: String
    let ensName: String?
    let image: URL?
    
    init(address: String, image: URL?, name: String?) {
        self.address = address
        self.ensName = name
        self.image = image
    }
}
