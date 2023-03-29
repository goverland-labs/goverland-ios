//
//  ApiError.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.03.23.
//

import Foundation

enum APIError: Error {
    case unknown
    case networkUnavailable
    case serverError(statusCode: Int)

    var localizedDescription: String {
        switch self {
        case .unknown:
            return "An unknown error occurred. Please try again later."
        case .networkUnavailable:
            return "Network is not available. Please try again later."
        case .serverError(let statusCode):
            return "Server error (\(statusCode)). Please try again later."
        }
    }
}
