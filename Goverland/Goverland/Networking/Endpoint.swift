//
//  Endpoint.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.03.23.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [String: String] { get }
    var queryParameters: [URLQueryItem]? { get }
    var body: Data? { get }

    associatedtype ResponseType: Decodable
}

extension APIEndpoint {
    var baseURL: URL {
        return URL(string: "https://api.goverland.xyz")!
    }

    var headers: [String: String] {
        return ["Content-Type": "application/json"]
    }
}

struct Status: Decodable {
    let status: String
}

struct HealthcheckEndpoint: APIEndpoint {
    typealias ResponseType = Status

    var path: String = "v1/healthcheck"
    var method: HttpMethod = .get
    var queryParameters: [URLQueryItem]?
    var body: Data? = nil

    init(queryParameters: [URLQueryItem]? = nil) {
        self.queryParameters = queryParameters
    }
}
