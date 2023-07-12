//
//  ProposalsSearchResultsDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 12.07.23.
//

import SwiftUI
import Combine

class ProposalsSearchResultsDataSource: ObservableObject {
    @Published var searchText = ""
    @Published var searchResultProposals: [Proposal] = []
    @Published var nothingFound: Bool = false
    private var cancellables = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable!

    init() {
        searchCancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.performSearch(searchText)
            }
    }

    private func performSearch(_ searchText: String) {
        nothingFound = false
        guard searchText != "" else { return }

        APIService.proposals(query: searchText)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.nothingFound = true
                }
            } receiveValue: { [weak self] proposals, headers in
                self?.nothingFound = proposals.isEmpty
                self?.searchResultProposals = proposals
            }
            .store(in: &cancellables)
    }
}

