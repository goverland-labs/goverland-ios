//
//  Dao.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-02.
//

import SwiftUI

struct Dao: Identifiable, Decodable {
    let id: UUID
    let name: String
    let image: URL?
}

struct DaoGroup: Identifiable, Decodable {
    let id: UUID
    let groupType: DaoCategory
    let daos: [Dao]
}

enum DaoCategory: String, Decodable, Identifiable {
    case social
    case `protocol`
    case investment
    case creator
    case service
    case collector
    case media
    case grant
    
    var id: Self { self }
    var sortingNumber: Int {
        switch self {
        case .social:
            return 0
        case .protocol:
            return 1
        case .investment:
            return 2
        case .creator:
            return 3
        case .service:
            return 4
        case .collector:
            return 5
        case .media:
            return 6
        case .grant:
            return 7
        }
    }
    
    var name: String {
        switch self {
        case .social:
            return "Social"
        case .protocol:
            return "Protocol"
        case .investment:
            return "Investment"
        case .creator:
            return "Creator"
        case .service:
            return "Service"
        case .collector:
            return "Collector"
        case .media:
            return "Media"
        case .grant:
            return "Grant"
        }
    }
}


extension Dao {
    static let gnosis = Dao(
        id: UUID(),
        name: "Gnosis DAO",
        image: URL(string: "https://cdn.stamp.fyi/space/gnosis.eth?s=164")!)
    static let aave = Dao(
        id: UUID(),
        name: "Aave",
        image: URL(string: "https://cdn.stamp.fyi/space/aave.eth?s=164"))
}
