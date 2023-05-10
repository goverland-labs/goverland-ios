//
//  Dao.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-02.
//

import SwiftUI

struct Dao: Identifiable, Decodable {
    let id: UUID
    let ensName: String
    let name: String
    let image: URL?
    let proposals: Int

    init(id: UUID, ensName: String, name: String, image: URL?, proposals: Int) {
        self.id = id
        self.ensName = ensName
        self.name = name
        self.image = image
        self.proposals = proposals
    }

    enum CodingKeys: String, CodingKey {
        case ensName = "id"
        case name
        case image
        case proposals = "proposals_count"
    }

    // TODO: finilize once API is ready
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()

        do {
            self.ensName = try container.decode(String.self, forKey: .ensName)
        } catch {
            self.ensName = "test.eth"
        }

        self.name = try container.decode(String.self, forKey: .name)

        do {
            self.image = try container.decode(URL.self, forKey: .image)
        } catch {
            self.image = URL(string: "https://cdn.stamp.fyi/space/gnosis.eth?s=164")!
        }

        do {
            self.proposals = try container.decode(Int.self, forKey: .proposals)
        } catch {
            self.proposals = 10
        }
    }
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
        ensName: "gnosis.eth",
        name: "Gnosis DAO",
        image: URL(string: "https://cdn.stamp.fyi/space/gnosis.eth?s=164")!,
        proposals: 100)
    static let aave = Dao(
        id: UUID(),
        ensName: "aave.eth",
        name: "Aave",
        image: URL(string: "https://cdn.stamp.fyi/space/aave.eth?s=164"),
        proposals: 150)
}
