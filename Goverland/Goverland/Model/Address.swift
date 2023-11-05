//
//  Address.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 20.04.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import BlockiesSwift

struct Address: Decodable, CustomStringConvertible {
    let value: String
    var blockie: Image? {
        let blockie = Blockies(seed: value.lowercased(),
                               size: 8,
                               scale: 4,
                               color: nil,
                               bgColor: nil,
                               spotColor: nil).createImage()
        if let blockie = blockie {
            return Image(uiImage: blockie)
        }
        return nil
    }

    var description: String { value }

    init(_ value: String) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try container.decode(String.self)
    }
}

extension Address {
    var short: String {
        "\(value.prefix(6))...\(value.suffix(4))"
    }
}
