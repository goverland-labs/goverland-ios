//
//  APIService.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.03.23.
//

import Combine
import Foundation

let DEFAULT_PAGINATION_COUNT = 20

class APIService {
    let networkManager: NetworkManager

    static let shared = APIService()

    private init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }

    func request<T: APIEndpoint>(_ endpoint: T) -> AnyPublisher<(T.ResponseType, HttpHeaders), APIError> {
        var components = URLComponents(url: endpoint.baseURL.appendingPathComponent(endpoint.path),
                                       resolvingAgainstBaseURL: false)!
        components.queryItems = endpoint.queryParameters

        var request = URLRequest(url: components.url!)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.allHTTPHeaderFields = endpoint.headers

        return networkManager.request(request)
            .tryMap { data, headers in
                let object = try JSONDecoder().decode(T.ResponseType.self, from: data)
                return (object, headers)
            }
            .receive(on: DispatchQueue.main)
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    ErrorViewModel.shared.setErrorMessage(apiError.localizedDescription)
                    return apiError
                } else {
                    // Decoding error. Don't show error to user.
                    // TODO: log into crashlytics
                    return APIError.unknown
                }
            }
            .eraseToAnyPublisher()
    }
}

extension APIService {
    static func daos(offset: Int = 0,
                     limit: Int = DEFAULT_PAGINATION_COUNT,
                     category: DaoCategory? = nil,
                     query: String? = nil) -> AnyPublisher<(DaoListEndpoint.ResponseType, HttpHeaders), APIError> {
        var queryParameters = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
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

    static func categories() -> AnyPublisher<(DaoCategotiesEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = DaoCategotiesEndpoint(queryParameters: nil)
        return shared.request(endpoint)
    }
}
