//
//  Address.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 20.04.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import BlockiesSwift
import CryptoSwift

struct Address: Codable, CustomStringConvertible {
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

// MARK: - EIP-55

extension Address {
    var checksum: String? {
        let lowercasedAddress = value.lowercased().stripHexPrefix()
        guard let hash = lowercasedAddress.data(using: .utf8)?.sha3(.keccak256).toHexString() else {
            return nil
        }

        var checksumAddress = "0x"
        for (character, hashCharacter) in zip(lowercasedAddress, hash) {
            if let intVal = Int(String(hashCharacter), radix: 16), intVal >= 8 {
                checksumAddress += String(character).uppercased()
            } else {
                checksumAddress += String(character)
            }
        }

        return checksumAddress
    }
}

fileprivate extension String {
    func stripHexPrefix() -> String {
        if self.hasPrefix("0x") {
            return String(self.dropFirst(2))
        }
        return self
    }
}
