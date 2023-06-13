//
//  Dao.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-02.
//

import SwiftUI

struct Dao: Identifiable, Decodable, Equatable {
    let id: UUID
    let ensName: String
    let name: String
    let image: URL?
    let proposals: Int
    let subscriptionMeta: SubscriptionMeta?

    init(id: UUID, ensName: String, name: String, image: URL?, proposals: Int, subscriptionMeta: SubscriptionMeta?) {
        self.id = id
        self.ensName = ensName
        self.name = name
        self.image = image
        self.proposals = proposals
        self.subscriptionMeta = subscriptionMeta
    }

    enum CodingKeys: String, CodingKey {
        case ensName = "id"
        case name
        case image
        case proposals = "proposals_count"
        case subscriptionMeta = "subscription_info"
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
        
        self.subscriptionMeta = try container.decode(SubscriptionMeta?.self, forKey: .subscriptionMeta)
    }
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

    static var values: [DaoCategory] {[
        .social, .protocol, .investment, .creator, .service, .collector, .media, .grant
    ]}

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

enum DaoSorting: String {
    /// Default sorting displays "promoted" DAOs first, and then by voters amount desc.
    case `default`
    case votersDesc
    case votersAsc
    case proposalsDesc
    case proposalsAsc
}

extension Dao {
    static let gnosis = Dao(
        id: UUID(),
        ensName: "gnosis.eth",
        name: "Gnosis DAO",
        image: URL(string: "https://cdn.stamp.fyi/space/gnosis.eth?s=164")!,
        proposals: 100,
        subscriptionMeta: nil)
    static let aave = Dao(
        id: UUID(),
        ensName: "aave.eth",
        name: "Aave",
        image: URL(string: "https://cdn.stamp.fyi/space/aave.eth?s=164"),
        proposals: 150,
        subscriptionMeta: nil)
}
