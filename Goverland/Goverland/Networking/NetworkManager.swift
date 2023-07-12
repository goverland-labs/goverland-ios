//
//  NetworkManager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.03.23.
//

import Combine
import Foundation

class NetworkManager {
    private let session: URLSession

    init() {
        let configuration = URLSessionConfiguration.default
        #if DEV
        configuration.timeoutIntervalForRequest = 3
        #else
        configuration.timeoutIntervalForRequest = 15
        #endif
        self.session = URLSession(configuration: configuration)
    }

    func request(_ urlRequest: URLRequest) -> AnyPublisher<(Data, HttpHeaders), APIError> {
        #if DEV
        print(urlRequest.description)
        #endif

        return session
            .dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                if let httpResponse = response as? HTTPURLResponse,
                    let headers = httpResponse.allHeaderFields as? HttpHeaders {
                    if httpResponse.statusCode == 401 {
                        throw APIError.notAuthorized
                    } else if httpResponse.statusCode == 404 {
                        throw APIError.notFound
                    } else if (500...599).contains(httpResponse.statusCode) {
                        throw APIError.serverError(statusCode: httpResponse.statusCode)
                    }
                    return (data, headers)
                } else {
                    logError(APIError.unknown)
                    throw APIError.unknown
                }
            }
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    return apiError
                }
                return APIError.system(description: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
