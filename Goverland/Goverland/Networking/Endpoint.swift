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
    var baseURL: URL { ConfigurationManager.baseURL }

    var headers: [String: String] {
        var headers = ["Content-Type": "application/json"]
        if !SettingKeys.shared.authToken.isEmpty {
            headers["Authorization"] = SettingKeys.shared.authToken
        }
        return headers
    }

    var body: Data? { nil }
    var queryParameters: [URLQueryItem]? { nil }
}

struct IgnoredResponse: Decodable {
    init(from decoder: Decoder) throws {}
    init() {}
}

// MARK: - Auth

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
    var headers: [String: String] {
        // do not set authorization header in this request
        return ["Content-Type": "application/json"]
    }

    var body: Data?

    init(deviceId: String) {
        self.body = try! JSONEncoder().encode(["device_id": deviceId])
    }
}

// MARK: - DAOs

struct DaoListEndpoint: APIEndpoint {
    typealias ResponseType = [Dao]

    var path: String = "dao"
    var method: HttpMethod = .get
    var queryParameters: [URLQueryItem]?

    init(queryParameters: [URLQueryItem]? = nil) {
        self.queryParameters = queryParameters
    }
}

struct DaoTopEndpoint: APIEndpoint {
    typealias ResponseType = [String: GroupedDaos]

    struct GroupedDaos: Decodable {
        let count: Int
        let list: [Dao]

        enum CodingKeys: String, CodingKey {
            case count            
            case list
        }
    }

    var path: String = "dao/top"
    var method: HttpMethod = .get
}

struct DaoInfoEndpoint: APIEndpoint {
    typealias ResponseType = Dao
    
    let daoID: UUID
    
    var path: String { "dao/\(daoID)" }
    var method: HttpMethod = .get

    init(daoID: UUID) {
        self.daoID = daoID
    }
}

struct DaoMonthlyActiveUsersEndpoint: APIEndpoint {
    typealias ResponseType = [MonthlyActiveUsers]
    
    let daoID: UUID
    var baseURL: URL { URL(string: "https://gist.githubusercontent.com/")! }
    var path: String { "JennyShalai/37990eed3bc1206af2f221906894e801/raw/74c429ba427acf0c84f1a5284fad73ac3ac6638e/gistfile1.txt" }
    //var path: String { "analytics/monthly-active-users/\(daoID)" }
    var method: HttpMethod = .get
    
    init(daoID: UUID) {
        self.daoID = daoID
    }
}

struct DaoUserBucketsEndpoint: APIEndpoint {
    typealias ResponseType = [UserBuckets]
    
    let daoID: UUID
    var baseURL: URL { URL(string: "https://gist.githubusercontent.com/")! }
    var path: String { "JennyShalai/ec1d19d5b1c110dc9d2d0a0d40118366/raw/6906f2236428f0f9f78b5054bd18545afc1b543c/gistfile1.txt" }
    //var path: String { "analytics/voter-buckets/\(daoID)" }
    var method: HttpMethod = .get
    
    init(daoID: UUID) {
        self.daoID = daoID
    }
}

// MARK: - Subscriptions

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
    
    init(subscriptionID: UUID) {
        self.subscriptionID = subscriptionID
    }
}

// MARK: - Proposals

struct ProposalsListEndpoint: APIEndpoint {
    typealias ResponseType = [Proposal]

    var path: String = "proposals"
    var method: HttpMethod = .get
    var queryParameters: [URLQueryItem]?

    init(queryParameters: [URLQueryItem]? = nil) {
        self.queryParameters = queryParameters
    }
}

struct TopProposalsListEndpoint: APIEndpoint {
    typealias ResponseType = [Proposal]

    var path: String = "proposals/top"
    var method: HttpMethod = .get
    var queryParameters: [URLQueryItem]?

    init(queryParameters: [URLQueryItem]? = nil) {
        self.queryParameters = queryParameters
    }
}


struct ProposalEndpoint: APIEndpoint {
    typealias ResponseType = Proposal

    let proposalID: UUID

    var path: String { "proposals/\(proposalID)" }
    var method: HttpMethod = .get

    init(proposalID: UUID) {
        self.proposalID = proposalID
    }
}

struct ProposalVotesEndpoint: APIEndpoint {
    typealias ResponseType = [Vote]

    let proposalID: String
    
    var path: String { "proposals/\(proposalID)/votes" }
    var method: HttpMethod = .get
    var queryParameters: [URLQueryItem]?

    init(proposalID: String, queryParameters: [URLQueryItem]? = nil) {
        self.queryParameters = queryParameters
        self.proposalID = proposalID
    }
}

// MARK: - Feed

struct InboxEventsEndpoint: APIEndpoint {
    typealias ResponseType = [InboxEvent]

    var path: String = "feed"
    var method: HttpMethod = .get
    var queryParameters: [URLQueryItem]?

    init(queryParameters: [URLQueryItem]? = nil) {
        self.queryParameters = queryParameters
    }
}

struct DaoEventsEndpoint: APIEndpoint {
    typealias ResponseType = [InboxEvent]

    let daoID: UUID

    var path: String { "dao/\(daoID)/feed" }
    var method: HttpMethod = .get
    var queryParameters: [URLQueryItem]?

    init(daoID: UUID, queryParameters: [URLQueryItem]? = nil) {
        self.daoID = daoID
        self.queryParameters = queryParameters
    }
}

struct MarkEventReadEndpoint: APIEndpoint {
    typealias ResponseType = IgnoredResponse

    let eventID: UUID

    var path: String { "feed/\(eventID)/mark-as-read" }
    var method: HttpMethod = .post

    init(eventID: UUID) {
        self.eventID = eventID
    }
}

struct MarkEventArchivedEndpoint: APIEndpoint {
    typealias ResponseType = IgnoredResponse

    let eventID: UUID

    var path: String { "feed/\(eventID)/archive" }
    var method: HttpMethod = .post

    init(eventID: UUID) {
        self.eventID = eventID
    }
}

// MARK: - Notifications

struct NotificationsSettingsEndpoint: APIEndpoint {
    typealias ResponseType = NotificationsSettings

    var path: String = "notifications/settings"
    var method: HttpMethod = .get
}

struct EnableNotificationsEndpoint: APIEndpoint {
    typealias ResponseType = IgnoredResponse

    var path: String = "notifications/settings"
    var method: HttpMethod = .post
    var body: Data?

    init(token: String) {
        self.body = try! JSONEncoder().encode(["token": token])
    }
}

struct DisableNotificationsEndpoint: APIEndpoint {
    typealias ResponseType = IgnoredResponse

    var path: String = "notifications/settings"
    var method: HttpMethod = .delete
}
