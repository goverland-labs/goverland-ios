//
//  StatsDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 22.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class StatsDataSource: ObservableObject, Refreshable {
    @Published var stats: Stats?
    private var cancellables = Set<AnyCancellable>()

    static let shared = StatsDataSource()

    private init() {}

    func refresh() {
        stats = nil
        cancellables = Set<AnyCancellable>()
        loadData()
    }

    private func loadData() {
        APIService.stats()
            .sink { _ in
                // do nothing
            } receiveValue: { [weak self] data, _ in
                self?.stats = data
            }
            .store(in: &cancellables)
    }
}
