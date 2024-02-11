//
//  Http.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-02-02.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

typealias HttpHeaders = [String: Any]

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
