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

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request(_ urlRequest: URLRequest) -> AnyPublisher<Data, APIError> {
        #if DEV
        print(urlRequest.description)
        #endif
        
        return session
            .dataTaskPublisher(for: urlRequest)
            .tryMap { data, response -> Data in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 404 {
                        throw APIError.networkUnavailable
                    } else if (500...599).contains(httpResponse.statusCode) {
                        throw APIError.serverError(statusCode: httpResponse.statusCode)
                    }
                }
                return data
            }
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    return apiError
                } else {
                    return APIError.unknown
                }
            }
            .eraseToAnyPublisher()
    }
}
