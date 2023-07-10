//
//  APIService.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.03.23.
//

import Combine
import Foundation

#if DEV
let DEFAULT_PAGINATION_COUNT = 10
#else
let DEFAULT_PAGINATION_COUNT = 20
#endif

class APIService {
    let networkManager: NetworkManager
    let decoder: JSONDecoder

    static let shared = APIService()

    private init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    func request<T: APIEndpoint>(_ endpoint: T, defaultErrorDisplay: Bool = true) -> AnyPublisher<(T.ResponseType, HttpHeaders), APIError> {
        var components = URLComponents(url: endpoint.baseURL.appendingPathComponent(endpoint.path),
                                       resolvingAgainstBaseURL: false)!
        components.queryItems = endpoint.queryParameters

        var request = URLRequest(url: components.url!)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.allHTTPHeaderFields = endpoint.headers

        return networkManager.request(request)
            .tryMap { [unowned self] data, headers in
                guard T.ResponseType.self != IgnoredResponse.self else {
                    let response = IgnoredResponse()
                    return (response as! T.ResponseType, headers)
                }
                let object = try self.decoder.decode(T.ResponseType.self, from: data)
                return (object, headers)
            }
            .receive(on: DispatchQueue.main)
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    if case .notAuthorized = apiError {
                        AuthManager.shared.updateToken()
                    }
                    if defaultErrorDisplay {
                        ErrorViewModel.shared.setErrorMessage(apiError.localizedDescription)
                    }
                    return apiError
                } else {
                    // Decoding error. Don't show error to user.
                    // TODO: log into crashlytics
                    #if DEV
                    print(error)
                    #endif
                    return APIError.unknown
                }
            }
            .eraseToAnyPublisher()
    }
}

extension APIService {

    // MARK: - Auth

    static func authToken(deviceId: String, defaultErrorDisplay: Bool) -> AnyPublisher<(AuthTokenEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = AuthTokenEndpoint(deviceId: deviceId)
        return shared.request(endpoint, defaultErrorDisplay: defaultErrorDisplay)
    }

    // MARK: - DAOs
    
    static func daos(offset: Int = 0,
                     limit: Int = DEFAULT_PAGINATION_COUNT,
                     sorting: DaoSorting = .default,
                     category: DaoCategory? = nil,
                     query: String? = nil) -> AnyPublisher<(DaoListEndpoint.ResponseType, HttpHeaders), APIError> {
        var queryParameters = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "sorting", value: "\(sorting)")
        ]
        if let category = category {
            queryParameters.append(URLQueryItem(name: "category", value: category.rawValue))
        }
        if let query = query {
            queryParameters.append(URLQueryItem(name: "query", value: query))
        }
        let endpoint = DaoListEndpoint(queryParameters: queryParameters)
        return shared.request(endpoint)
    }

    static func daoGrouped() -> AnyPublisher<(DaoGroupedEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = DaoGroupedEndpoint()
        return shared.request(endpoint)
    }
    
    static func daoInfo(id: UUID) -> AnyPublisher<(DaoInfoEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = DaoInfoEndpoint(daoID: id)
        return shared.request(endpoint)
    }

    // MARK: - Subscriptions
    
    static func subscriptions(offset: Int = 0,
                              limit: Int = 1000,
                              sorting: DaoSorting = .default) -> AnyPublisher<(SubscriptionsEndpoint.ResponseType, HttpHeaders), APIError> {
        let queryParameters = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "sorting", value: "\(sorting)")
        ]
        let endpoint = SubscriptionsEndpoint(queryParameters: queryParameters)
        return shared.request(endpoint)
    }
    
    static func createSubscription(id: UUID) -> AnyPublisher<(CreateSubscriptionEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = CreateSubscriptionEndpoint(daoID: id)
        return shared.request(endpoint)
    }
    
    static func deleteSubscription(id: UUID) -> AnyPublisher<(DeleteSubscriptionEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = DeleteSubscriptionEndpoint(subscriptionID: id)
        return shared.request(endpoint)
    }

    // MARK: - Proposals
    
    static func proposals(offset: Int = 0,
                          limit: Int = DEFAULT_PAGINATION_COUNT,
                          query: String? = nil) -> AnyPublisher<(ProposalsListEndpoint.ResponseType, HttpHeaders), APIError> {
        var queryParameters = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        if let query = query {
            queryParameters.append(URLQueryItem(name: "query", value: query))
        }
        let endpoint = ProposalsListEndpoint(queryParameters: queryParameters)
        return shared.request(endpoint)
    }

    static func proposal(id: UUID) -> AnyPublisher<(ProposalEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = ProposalEndpoint(proposalID: id)
        return shared.request(endpoint)
    }
    
    static func votes(proposalID: UUID,
                       offset: Int = 0,
                       limit: Int = DEFAULT_PAGINATION_COUNT,
                       query: String? = nil) -> AnyPublisher<(ProposalVotesEndpoint.ResponseType, HttpHeaders), APIError> {
        let queryParameters = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        let endpoint = ProposalVotesEndpoint(proposalID: proposalID, queryParameters: queryParameters)
        return shared.request(endpoint)
    }

    // MARK: - Feed

    static func inboxEvents(offset: Int = 0,
                            limit: Int = DEFAULT_PAGINATION_COUNT) -> AnyPublisher<(InboxEventsEndpoint.ResponseType, HttpHeaders), APIError> {
        let queryParameters = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        let endpoint = InboxEventsEndpoint(queryParameters: queryParameters)
        return shared.request(endpoint)
    }

    static func daoEvents(daoID: UUID,
                          offset: Int = 0,
                          limit: Int = DEFAULT_PAGINATION_COUNT) -> AnyPublisher<(DaoEventsEndpoint.ResponseType, HttpHeaders), APIError> {
        let queryParameters = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        let endpoint = DaoEventsEndpoint(daoID: daoID, queryParameters: queryParameters)
        return shared.request(endpoint)
    }

    static func markEventRead(eventID: UUID) -> AnyPublisher<(MarkEventReadEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = MarkEventReadEndpoint(eventID: eventID)
        return shared.request(endpoint)
    }

    static func markEventArchived(eventID: UUID) -> AnyPublisher<(MarkEventReadEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = MarkEventArchivedEndpoint(eventID: eventID)
        return shared.request(endpoint)
    }

    // MARK: - Notifications

    // TODO: atm this is not used. We will use it once we have granular notifications control
    static func notificationsSettings() -> AnyPublisher<(NotificationsSettingsEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = NotificationsSettingsEndpoint()
        return shared.request(endpoint)
    }

    static func enableNotifications(_ token: String, defaultErrorDisplay: Bool) -> AnyPublisher<(EnableNotificationsEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = EnableNotificationsEndpoint(token: token)
        return shared.request(endpoint, defaultErrorDisplay: defaultErrorDisplay)
    }

    static func disableNotifications() -> AnyPublisher<(DisableNotificationsEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = DisableNotificationsEndpoint()
        return shared.request(endpoint)
    }
}
