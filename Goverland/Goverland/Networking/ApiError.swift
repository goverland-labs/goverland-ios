//
//  ApiError.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.03.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation

enum APIError: Error {
    case badRequest(error: String)
    case notAuthorized
    case notFound
    case serverError(statusCode: Int)
    case system(description: String)
    case unknown

    var localizedDescription: String {
        switch self {
        case .badRequest(let error):
            return error
        case .notAuthorized:
            return "Authorization error. Please try again later."
        case .notFound:
            return "Content not found."
        case .serverError(let statusCode):
            return "Server error (\(statusCode)). Please try again later."
        case .system(let description):
            return description
        case .unknown:
            return "An unknown error occurred. Please try again later."
        }
    }
}
