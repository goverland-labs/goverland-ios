//
//  Endpoint.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.03.23.
//  Copyright © Goverland Inc. All rights reserved.
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

// MARK: - DAO Insights

struct DaoMonthlyActiveUsersEndpoint: APIEndpoint {
    typealias ResponseType = [MonthlyActiveUsers]
    
    let daoID: UUID
    var path: String { "analytics/monthly-active-users/\(daoID)" }
    var method: HttpMethod = .get
    
    init(daoID: UUID) {
        self.daoID = daoID
    }
}

struct DaoUserBucketsEndpoint: APIEndpoint {
    typealias ResponseType = [UserBuckets]
    
    let daoID: UUID
    var path: String { "analytics/voter-buckets/\(daoID)" }
    var method: HttpMethod = .get
    
    init(daoID: UUID) {
        self.daoID = daoID
    }
}

struct DaoExclusiveVotersEndpoint: APIEndpoint {
    typealias ResponseType = ExclusiveVoters
    
    let daoID: UUID
    var path: String { "analytics/exclusive-voters/\(daoID)" }
    var method: HttpMethod = .get
    
    init(daoID: UUID) {
        self.daoID = daoID
    }
}

struct SuccessfulProposalsEndpoint: APIEndpoint {
    typealias ResponseType = SuccessfulProposals
    
    let daoID: UUID
    var path: String { "analytics/succeeded-proposals-count/\(daoID)" }
    var method: HttpMethod = .get
    
    init(daoID: UUID) {
        self.daoID = daoID
    }
}

struct MonthlyNewProposalsEndpoint: APIEndpoint {
    typealias ResponseType = [MonthlyNewProposals]
    
    let daoID: UUID
    var path: String { "analytics/monthly-new-proposals/\(daoID)" }
    var method: HttpMethod = .get
    
    init(daoID: UUID) {
        self.daoID = daoID
    }
}

struct MutualDaosEndpoint: APIEndpoint {
    typealias ResponseType = [MutualDao]
    
    let daoID: UUID
    var path: String { "analytics/mutual-daos/\(daoID)" }
    var method: HttpMethod = .get
    var queryParameters: [URLQueryItem]?

    init(daoID: UUID, queryParameters: [URLQueryItem]? = nil) {
        self.daoID = daoID
        self.queryParameters = queryParameters
    }
}

struct TopVotePowerVotersEndpoint: APIEndpoint {
    typealias ResponseType = [VotePowerVoter]
    
    let daoID: UUID
    var path: String { "analytics/top-voters-by-vp/\(daoID)" }
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

struct ProposalVotesEndpoint<ChoiceType: Decodable>: APIEndpoint {
    typealias ResponseType = [Vote<ChoiceType>]

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

struct RecentlyViewedDaosEndpoint: APIEndpoint {
    typealias ResponseType = [Dao]

    var path: String { "dao/recent" }
    var method: HttpMethod = .get
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

struct MarkAllEventsReadEndpoint: APIEndpoint {
    typealias ResponseType = IgnoredResponse

    var path: String { "feed/mark-as-read" }
    var method: HttpMethod = .post
    var body: Data?

    init(before date: Date) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        self.body = try! encoder.encode(["before": date])
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

struct MarkEventUnarchivedEndpoint: APIEndpoint {
    typealias ResponseType = IgnoredResponse

    let eventID: UUID

    var path: String { "feed/\(eventID)/unarchive" }
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
