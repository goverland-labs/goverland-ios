//
//  SearchViewDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 04.10.23.
//

import Foundation
import SwiftUI

enum SearchFilter: Int, FilterOptions {
    case proposals = 0
    case daos

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
    @Published var filter: SearchFilter = .proposals
    @Published var path = NavigationPath()

    static let shared = SearchModel()

    private init() {}

    func refresh() {
        filter = .proposals
        path = NavigationPath()
    }
}
