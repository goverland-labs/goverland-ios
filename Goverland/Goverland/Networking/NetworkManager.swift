//
//  NetworkManager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.03.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Combine
import Foundation

class NetworkManager {
    private let session: URLSession

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = ConfigurationManager.timeout
        self.session = URLSession(configuration: configuration)
    }

    func request(_ urlRequest: URLRequest) -> AnyPublisher<(Data, HttpHeaders), APIError> {
#if STAGE
        var body = ""
        if let bodyData = urlRequest.httpBody {
            body = String(data: bodyData, encoding: .utf8)!
        }
        logInfo("[REQUEST \(urlRequest.httpMethod ?? "")] \(urlRequest.description); \(body)")
#endif

        return session
            .dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                if let httpResponse = response as? HTTPURLResponse,
                   let headers = httpResponse.allHeaderFields as? HttpHeaders {
                    switch httpResponse.statusCode {
                    case 400, 405...499:
                        let errorString: String
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                           let dictionary = json as? [String: Any],
                           let errorMessage = dictionary["message"] as? String {
                            errorString = errorMessage
                        } else {
                            logInfo("[App] wrong backend error response format. Message not found.")
                            errorString = "Unknown error"
                        }
                        throw APIError.badRequest(error: errorString)
                    case 401:
                        throw APIError.notAuthorized
                    case 403:
                        throw APIError.forbidden
                    case 404:
                        throw APIError.notFound
                    case 500...599:
                        throw APIError.serverError(statusCode: httpResponse.statusCode)
                    default:
                        // all good
                        return (data, headers)
                    }
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
