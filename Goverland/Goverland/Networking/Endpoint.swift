//
//  Endpoint.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.03.23.
//

import Foundation

typealias HttpHeaders = [String: Any]

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol APIEndpoint {
    associatedtype ResponseType: Decodable

    var baseURL: URL { get }
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [String: String] { get }
    var queryParameters: [URLQueryItem]? { get }
    var body: Data? { get }
}

extension APIEndpoint {
    var baseURL: URL {
        return URL(string: "https://inbox.staging.goverland.xyz")!
    }

    var headers: [String: String] {
        var headers = ["Content-Type": "application/json"]
        if !SettingKeys.shared.authToken.isEmpty {
            headers["Authorization"] = SettingKeys.shared.authToken
        }
        return headers
    }
}

struct IgnoredResponse: Decodable {
    init(from decoder: Decoder) throws {}
    init() {}
}

// MARK: - Inbox service endpoints

struct AuthTokenEndpoint: APIEndpoint {
    typealias ResponseType = AuthTokenResponse

    struct AuthTokenResponse: Decodable {
        let sessionId: String

        enum CodingKeys: String, CodingKey {
            case sessionId = "session_id"
        }
    }

    var path: String = "auth/guest"
    var method: HttpMethod = .post
    var queryParameters: [URLQueryItem]?
    var headers: [String: String] {
        // do not set authorization header in this request
        return ["Content-Type": "application/json"]
    }

    var body: Data?

    init(deviceId: String) {
        self.body = try! JSONEncoder().encode(["device_id": deviceId])
    }
}

struct DaoListEndpoint: APIEndpoint {
    typealias ResponseType = [Dao]

    var path: String = "dao"
    var method: HttpMethod = .get
    var queryParameters: [URLQueryItem]?

    var body: Data?

    init(queryParameters: [URLQueryItem]? = nil) {
        self.queryParameters = queryParameters
    }
}

struct DaoGroupedEndpoint: APIEndpoint {
    typealias ResponseType = [String: GroupedDaos]

    struct GroupedDaos: Decodable {
        let count: Int
        let subscriptionsCount: Int?
        let list: [Dao]

        enum CodingKeys: String, CodingKey {
            case count
            case subscriptionsCount = "subscriptions_count"
            case list
        }
    }

    var path: String = "dao/top"
    var method: HttpMethod = .get
    var queryParameters: [URLQueryItem]?
    
    var body: Data?
    
    init(queryParameters: [URLQueryItem]? = nil) {
        self.queryParameters = queryParameters
    }
}

struct DaoInfoEndpoint: APIEndpoint {
    typealias ResponseType = Dao
    
    let daoID: UUID
    
    var path: String { "dao/\(daoID)" }
    var method: HttpMethod = .get
    var queryParameters: [URLQueryItem]?
    
    var body: Data?

    init(daoID: UUID) {
        self.daoID = daoID
    }
}

struct SubscriptionsEndpoint: APIEndpoint {
    typealias ResponseType = [Subscription]

    var path: String = "subscriptions"
    var method: HttpMethod = .get
    var queryParameters: [URLQueryItem]?
    
    var body: Data?
    
    init(queryParameters: [URLQueryItem]? = nil) {
        self.queryParameters = queryParameters
    }
}

struct CreateSubscriptionEndpoint: APIEndpoint {
    typealias ResponseType = Subscription

    var path: String = "subscriptions"
    var method: HttpMethod = .post
    var queryParameters: [URLQueryItem]?

    var body: Data?
    
    init(daoID: UUID) {
        self.body = try! JSONEncoder().encode(["dao": daoID])
    }
}

struct DeleteSubscriptionEndpoint: APIEndpoint {
    typealias ResponseType = IgnoredResponse

    let subscriptionID: UUID

    var path: String { "subscriptions/\(subscriptionID)" }
    var method: HttpMethod = .delete
    var queryParameters: [URLQueryItem]?

    var body: Data?
    
    init(subscriptionID: UUID) {
        self.subscriptionID = subscriptionID
    }
}

struct InboxEventsEndpoint: APIEndpoint {
    typealias ResponseType = [InboxEvent]

    var path: String = "feed"
    var method: HttpMethod = .get
    var queryParameters: [URLQueryItem]?

    var body: Data?

    init(queryParameters: [URLQueryItem]? = nil) {
        self.queryParameters = queryParameters
    }
}

struct ProposalEndpoint: APIEndpoint {
    typealias ResponseType = Proposal

    let proposalID: UUID

    var path: String { "proposals/\(proposalID)" }
    var method: HttpMethod = .get
    var queryParameters: [URLQueryItem]?

    var body: Data?

    init(proposalID: UUID) {
        self.proposalID = proposalID
    }
}

struct ProposalVotesEndpoint: APIEndpoint {
    typealias ResponseType = [Votes]
    
    struct Votes: Decodable {
        let id: UUID

        enum CodingKeys: String, CodingKey {
            case id = "id"
        }
    }

    let proposalID: UUID
    
    var path: String { "proposals/\(proposalID)/votes" }
    var method: HttpMethod = .get
    var queryParameters: [URLQueryItem]?
    
    var body: Data?
    
    init(proposalID: UUID, queryParameters: [URLQueryItem]? = nil) {
        self.queryParameters = queryParameters
        self.proposalID = proposalID
    }
}
