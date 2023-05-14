//
//  Endpoint.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.03.23.
//

import Foundation

typealias HttpHeaders = [String: Any]

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
        return URL(string: "https://inbox.staging.goverland.xyz")!
    }

    var headers: [String: String] {
        return ["Content-Type": "application/json"]
    }
}

// MARK: - Inbox service endpoints

struct DaoListEndpoint: APIEndpoint {
    typealias ResponseType = [Dao]

    var path: String = "dao"
    var method: HttpMethod = .get
    var queryParameters: [URLQueryItem]?

    var body: Data?

    init(queryParameters: [URLQueryItem]? = nil) {
        self.queryParameters = queryParameters
    }
}

struct DaoCategotiesEndpoint: APIEndpoint {
    typealias ResponseType = [String:[Dao]]
    
    var path: String = "dao/top"
    var method: HttpMethod = .get
    var queryParameters: [URLQueryItem]?
    
    var body: Data?
    
    init(queryParameters: [URLQueryItem]? = nil) {
        self.queryParameters = queryParameters
    }
}
