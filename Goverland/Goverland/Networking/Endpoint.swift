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
        let list: [Dao]
    }

    var path: String = "dao/top"
    var method: HttpMethod = .get
    var queryParameters: [URLQueryItem]?
    
    var body: Data?
    
    init(queryParameters: [URLQueryItem]? = nil) {
        self.queryParameters = queryParameters
    }
}

struct FollowDaoEndpoint: APIEndpoint {
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
