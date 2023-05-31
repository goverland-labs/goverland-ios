//
//  ApiError.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.03.23.
//

import Foundation

enum APIError: Error {
    case notFound
    case serverError(statusCode: Int)
    case system(description: String)
    case unknown

    var localizedDescription: String {
        switch self {
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
