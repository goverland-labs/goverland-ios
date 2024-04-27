//
//  APIService.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.03.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Combine
import Foundation

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
                    switch apiError {
                    case .notAuthorized, .forbidden:
                        Task {
                            try! await UserProfile.signOutSelected(logErrorIfNotFound: false)
                        }
                    default: 
                        break
                    }
                    if defaultErrorDisplay {
                        logInfo("[App] Backend error: \(apiError.localizedDescription)")
                        showToast(apiError.localizedDescription)
                    }
                    return apiError
                } else {
                    logError(error)
                    if defaultErrorDisplay {
                        showToast(error.localizedDescription)
                    }
                    return APIError.unknown
                }
            }
            .eraseToAnyPublisher()
    }
}
