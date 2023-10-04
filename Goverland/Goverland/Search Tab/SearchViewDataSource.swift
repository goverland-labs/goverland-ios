//
//  SearchViewDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 04.10.23.
//

import Foundation

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

class SearchViewDataSource: ObservableObject {
    @Published var filter: SearchFilter = .proposals
    @Published var daos = GroupedDaosDataSource()
    @Published var proposals = TopProposalDataSource()
    @Published var proposalsSearch = ProposalsSearchResultsDataSource()

    static let shared = SearchViewDataSource()

    private init() {}
}
