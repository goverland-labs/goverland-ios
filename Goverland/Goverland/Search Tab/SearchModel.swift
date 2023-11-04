//
//  SearchViewDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 04.10.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation
import SwiftUI

enum SearchFilter: Int, FilterOptions {
    case daos = 0
    case proposals

    var localizedName: String {
        switch self {
        case .daos:
            return "DAOs"
        case .proposals:
            return "Proposals"
        }
    }
}

class SearchModel: ObservableObject {
    @Published var filter: SearchFilter = .daos
    @Published var path = NavigationPath()

    static let shared = SearchModel()

    private init() {}

    func refresh() {
        filter = .daos
        path = NavigationPath()
    }
}
