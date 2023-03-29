//
//  APIService.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.03.23.
//

import Combine
import Foundation

class APIService {
    let networkManager: NetworkManager

    static let shared = APIService()

    private init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }

    func request<T: APIEndpoint>(_ endpoint: T) -> AnyPublisher<T.ResponseType, APIError> {
        var components = URLComponents(url: endpoint.baseURL.appendingPathComponent(endpoint.path),
                                       resolvingAgainstBaseURL: false)!
        components.queryItems = endpoint.queryParameters

        var request = URLRequest(url: components.url!)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.allHTTPHeaderFields = endpoint.headers

        return networkManager.request(request)
            .decode(type: T.ResponseType.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    ErrorViewModel.shared.setErrorMessage(apiError.localizedDescription)
                    return apiError
                } else {
                    // Decoding error. Don't show error to user.
                    return APIError.unknown
                }
            }
            .eraseToAnyPublisher()
    }
}

extension APIService {
    static func healthCheck() -> AnyPublisher<HealthcheckEndpoint.ResponseType, APIError> {
        let endpoint = HealthcheckEndpoint(queryParameters: [URLQueryItem(name: "value", value: "test")])
        return shared.request(endpoint)
    }
}
