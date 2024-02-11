//
//  Network.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 31.01.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct Network {
    let id: String
    let name: String
    let blockUrlTemplate: String

    static func from(id: String) -> Network? {
        switch id {
        case "1":
            return Network(id: id,
                           name: "Ethereum",
                           blockUrlTemplate: "https://etherscan.io/block/{}")

        case "56":
            return Network(id: id,
                           name: "Binance Smart Chain",
                           blockUrlTemplate: "https://bscscan.com/block/{}")

        case "137":
            return Network(id: id,
                           name: "Polygon",
                           blockUrlTemplate: "https://polygonscan.com/block/{}")

        case "42161":
            return Network(id: id,
                           name: "Arbitrum",
                           blockUrlTemplate: "https://arbiscan.io/block/{}")

        case "100":
            return Network(id: id,
                           name: "Gnosis Chain",
                           blockUrlTemplate: "https://gnosisscan.io/block/{}")

        case "10":
            return Network(id: id,
                           name: "Optimism",
                           blockUrlTemplate: "https://optimistic.etherscan.io/block/{}")

        case "324":
            return Network(id: id,
                           name: "zkSync Era",
                           blockUrlTemplate: "https://explorer.zksync.io/batch/{}")

        default:
            return nil
        }
    }
}
