//
//  Dao.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-02.
//

import SwiftUI
import SwiftDate

struct Dao: Identifiable, Decodable, Equatable {
    let id: UUID
    let alias: String
    let name: String
    let avatar: URL?
    let createdAt: Date
    let activitySince: Date?
    let about: [DaoBody]?
    let proposals: Int
    let members: Int
    let subscriptionMeta: SubscriptionMeta?
    let website: URL?
    let twitter: String?
    let github: String?
    let coingecko: String?
    let terms: URL?
    
    init(id: UUID,
         alias: String,
         name: String,
         image: URL?,
         createdAt: Date,
         activitySince: Date?,
         about: [DaoBody]?,
         proposals: Int,
         members: Int,
         subscriptionMeta: SubscriptionMeta?,
         website: URL?,
         twitter: String?,
         github: String?,
         coingecko: String?,
         terms: URL?) {
        self.id = id
        self.alias = alias
        self.name = name
        self.avatar = image
        self.createdAt = createdAt
        self.activitySince = activitySince
        self.about = about
        self.proposals = proposals
        self.members = members
        self.subscriptionMeta = subscriptionMeta
        self.website = website
        self.twitter = twitter
        self.github = github
        self.coingecko = coingecko
        self.terms = terms
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case alias
        case name
        case avatar
        case createdAt = "created_at"
        case activitySince = "activity_since"
        case about
        case proposals = "proposals_count"
        case members = "followers_count"
        case subscriptionMeta = "subscription_info"
        case website
        case twitter
        case github
        case coingecko
        case email
        case terms
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.alias = try container.decode(String.self, forKey: .alias)
        self.name = try container.decode(String.self, forKey: .name)

        // TODO: figure our with backend why sometimes avatar is Invalid URL string.
        self.avatar = try? container.decodeIfPresent(URL.self, forKey: .avatar)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.activitySince = try container.decodeIfPresent(Date.self, forKey: .activitySince)
        self.about = try container.decodeIfPresent([DaoBody].self, forKey: .about)
        self.proposals = try container.decode(Int.self, forKey: .proposals)
        self.members = try container.decode(Int.self, forKey: .members)
        self.subscriptionMeta = try container.decodeIfPresent(SubscriptionMeta.self, forKey: .subscriptionMeta)
        self.website = try? container.decodeIfPresent(URL.self, forKey: .website)
        self.twitter = try container.decodeIfPresent(String.self, forKey: .twitter)
        self.github = try container.decodeIfPresent(String.self, forKey: .github)
        self.coingecko = try container.decodeIfPresent(String.self, forKey: .coingecko)

        // can be empty string
        self.terms = try? container.decodeIfPresent(URL.self, forKey: .terms)
    }
    
    struct DaoBody: Decodable {
        let type: BodyType
        let body: String

        enum BodyType: String, Decodable {
            case markdown
            case html
        }
    }
    
    static func == (lhs: Dao, rhs: Dao) -> Bool {
        lhs.id == rhs.id
    }
}

enum DaoCategory: String, Identifiable {
    case new = "new_daos"
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
        .new, .social, .protocol, .investment, .creator, .service, .collector, .media, .grant
    ]}
    
    var name: String {
        switch self {
        case .new:
            return "New"
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
        alias: "gnosis.eth",
        name: "Gnosis DAO",
        image: URL(string: "https://cdn.stamp.fyi/space/gnosis.eth?s=164")!,
        createdAt: .now - 5.days,
        activitySince: .now - 1.years,
        about: [],
        proposals: 100,
        members: 4567,
        subscriptionMeta: nil,
        website: URL(string: "https://gnosis.io"),
        twitter: "gnosisdao",
        github: "gnosis",
        coingecko: "gnosis",
        terms: nil)
    static let aave = Dao(
        id: UUID(),
        alias: "aave.eth",
        name: "Aave",
        image: URL(string: "https://cdn.stamp.fyi/space/aave.eth?s=164"),
        createdAt: .now - 5.days,
        activitySince: .now - 1.years,
        about: [],
        proposals: 150,
        members: 45678,
        subscriptionMeta: nil,
        website: nil,
        twitter: "AaveAave",
        github: "aave",
        coingecko: "aave",
        terms: nil)
}
