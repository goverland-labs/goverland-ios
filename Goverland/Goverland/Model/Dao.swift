//
//  Dao.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-02.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct Dao: Identifiable, Decodable, Equatable, Hashable {
    let id: UUID
    let alias: String
    let name: String
    let avatars: [Avatar]
    let createdAt: Date
    let activitySince: Date?
    let about: [DaoBody]?
    let categories: [DaoCategory]
    let proposals: Int
    let voters: Int
    let activeVotes: Int
    let verified: Bool
    let subscriptionMeta: SubscriptionMeta?
    let website: URL?
    let X: String?
    let github: String?
    let coingecko: String?
    let terms: URL?
    let delegation: Delegation?

    var snapshotUrl: URL? {
        Utils.urlFromString("https://snapshot.box/#/s:\(alias)")
    }

    var goverlandUrl: URL? {
        Utils.urlFromString("https://app.goverland.xyz/dao/\(alias)")
    }

    init(id: UUID,
         alias: String,
         name: String,
         avatars: [Avatar],
         createdAt: Date,
         activitySince: Date?,
         about: [DaoBody]?,
         categories: [DaoCategory],
         proposals: Int,
         voters: Int,
         activeVotes: Int,
         verified: Bool,
         subscriptionMeta: SubscriptionMeta?,
         website: URL?,
         X: String?,
         github: String?,
         coingecko: String?,
         terms: URL?,
         delegation: Delegation?) {
        self.id = id
        self.alias = alias
        self.name = name
        self.avatars = avatars
        self.createdAt = createdAt
        self.activitySince = activitySince
        self.about = about
        self.categories = categories
        self.proposals = proposals
        self.voters = voters
        self.activeVotes = activeVotes
        self.verified = verified
        self.subscriptionMeta = subscriptionMeta
        self.website = website
        self.X = X
        self.github = github
        self.coingecko = coingecko
        self.terms = terms
        self.delegation = delegation
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case alias
        case name
        case avatars
        case createdAt = "created_at"
        case activitySince = "activity_since"
        case about
        case categories
        case proposals = "proposals_count"
        case voters = "voters_count"
        case activeVotes = "active_votes"
        case verified
        case subscriptionMeta = "subscription_info"
        case website
        case X = "twitter"
        case github
        case coingecko
        case email
        case terms
        case delegation
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.alias = try container.decode(String.self, forKey: .alias)
        self.name = try container.decode(String.self, forKey: .name)

        // falback
        if let avatars = try container.decodeIfPresent([Avatar].self, forKey: .avatars) {
            self.avatars = avatars
        } else {
            self.avatars = [
                Avatar(size: .xs, link: URL(string: "https://cdn.stamp.fyi/space/\(alias)?s=\(Avatar.Size.xs.daoImageSize * 2)")!),
                Avatar(size: .s, link: URL(string: "https://cdn.stamp.fyi/space/\(alias)?s=\(Avatar.Size.s.daoImageSize * 2)")!),
                Avatar(size: .m, link: URL(string: "https://cdn.stamp.fyi/space/\(alias)?s=\(Avatar.Size.m.daoImageSize * 2)")!),
                Avatar(size: .l, link: URL(string: "https://cdn.stamp.fyi/space/\(alias)?s=\(Avatar.Size.l.daoImageSize * 2)")!),
                Avatar(size: .xl, link: URL(string: "https://cdn.stamp.fyi/space/\(alias)?s=\(Avatar.Size.xl.daoImageSize * 2)")!)
            ]
        }

        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.activitySince = try container.decodeIfPresent(Date.self, forKey: .activitySince)

        do {
            self.about = try container.decodeIfPresent([DaoBody].self, forKey: .about)
        } catch {
            throw GError.errorDecodingData(error: error, context: "Decoding `about`: DAO ID: \(id)")
        }

        do {
            self.categories = try container.decode([DaoCategory].self, forKey: .categories)
        } catch {
            throw GError.errorDecodingData(error: error, context: "Decoding `categories`: DAO ID: \(id)")
        }

        self.proposals = try container.decode(Int.self, forKey: .proposals)
        self.voters = try container.decode(Int.self, forKey: .voters)
        self.activeVotes = try container.decode(Int.self, forKey: .activeVotes)
        self.verified = try container.decode(Bool.self, forKey: .verified)

        do {
            self.subscriptionMeta = try container.decodeIfPresent(SubscriptionMeta.self, forKey: .subscriptionMeta)
        } catch {
            throw GError.errorDecodingData(error: error, context: "Decoding `subscriptionMeta`: DAO ID: \(id)")
        }

        self.website = try? container.decodeIfPresent(URL.self, forKey: .website)
        self.X = try container.decodeIfPresent(String.self, forKey: .X)
        self.github = try container.decodeIfPresent(String.self, forKey: .github)
        self.coingecko = try container.decodeIfPresent(String.self, forKey: .coingecko)

        // can be empty string
        let _terms = try? container.decodeIfPresent(URL.self, forKey: .terms)
        if let _terms {
            if _terms.absoluteString.hasPrefix("ipfs://") {
                let validString = "https://snapshot.4everland.link/ipfs/\(_terms.absoluteString.dropFirst(7))"
                self.terms = URL(string: validString)
            } else {
                self.terms = _terms
            }
        } else {
            self.terms = nil
        }

        do {
            self.delegation = try container.decodeIfPresent(Delegation.self, forKey: .delegation)
        } catch {
            self.delegation = nil
            logInfo("[App] Could not decode Delegation for DAO: \(name)")
        }
    }

    static func == (lhs: Dao, rhs: Dao) -> Bool {
        lhs.id == rhs.id && lhs.subscriptionMeta?.id == rhs.subscriptionMeta?.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(subscriptionMeta?.id.hashValue ?? 0)
    }

    func avatar(size: Avatar.Size) -> URL {
        if let avatar = avatars.first(where: { $0.size == size }) {
            return avatar.link
        } else {
            return URL(string: "https://cdn.stamp.fyi/space/\(alias)?s=\(size.daoImageSize * 2)")!
        }
    }

    func withSubscriptionMeta(_ subscriptionMeta: SubscriptionMeta?) -> Self {
        .init(id: id,
              alias: alias,
              name: name,
              avatars: avatars,
              createdAt: createdAt,
              activitySince: activitySince,
              about: about,
              categories: categories,
              proposals: proposals,
              voters: voters,
              activeVotes: activeVotes,
              verified: verified,
              subscriptionMeta: subscriptionMeta,
              website: website,
              X: X,
              github: github,
              coingecko: coingecko,
              terms: terms, 
              delegation: delegation)
    }
}

struct DaoBody: Decodable {
    let type: BodyType
    let body: String

    enum BodyType: String, Decodable {
        case markdown
        case html
    }
}

struct Delegation: Decodable {
    let type: DelegationType

    enum DelegationType: String, Decodable {
        case splitDelegation = "split-delegation"
    }
}

enum DaoCategory: String, Identifiable, Decodable {
    case new = "new_daos"
    case popular = "popular_daos"
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
        .popular, .new, .protocol, .grant, .service, .social, .media, .creator, .investment, .collector
    ]}
    
    var name: String {
        switch self {
        case .new:
            return "New"
        case .popular:
            return "Popular"
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
