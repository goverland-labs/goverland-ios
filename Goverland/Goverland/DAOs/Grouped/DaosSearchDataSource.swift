//
//  DaosSearchDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 05.10.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation
import Combine

class DaosSearchDataSource: ObservableObject {
    @Published var searchText = ""
    @Published var searchResultDaos: [Dao] = []
    @Published var nothingFound: Bool = false
    private var cancellables = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable!

    static let shared = DaosSearchDataSource()

    private init() {
        searchCancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.performSearch(searchText)
            }
    }

    func refresh() {
        searchText = ""
        searchResultDaos = []
        nothingFound = false
        cancellables = Set<AnyCancellable>()
        // do not clear searchCancellable
    }

    private func performSearch(_ searchText: String) {
        nothingFound = false
        guard searchText != "" else { return }

        APIService.daos(query: searchText)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.nothingFound = true
                }
            } receiveValue: { [weak self] result, headers in
                self?.nothingFound = result.isEmpty
                self?.searchResultDaos = result
            }
            .store(in: &cancellables)
    }
}
