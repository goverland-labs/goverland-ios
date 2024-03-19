//
//  RecommendedDaosDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class RecommendedDaosDataSource: ObservableObject {
    @Published private(set) var recommendedDaos: [Dao]?

    static let shared = RecommendedDaosDataSource()

    private var cancellables = Set<AnyCancellable>()

    private init() {}

    func getRecommendedDaos() {
        logInfo("[App] Get recommended DAOs")
        recommendedDaos = nil
        APIService.profileDaoRecommendation()
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    // If request failed, we will not show DAO recommendations
                    logInfo("[App] Recommended DAOs: failure")
                    self?.recommendedDaos = []
                }
            } receiveValue: { [weak self] daos, headers in
                logInfo("[App] Found recommended DAOs: \(daos.count)")
                self?.recommendedDaos = daos
            }
            .store(in: &cancellables)
    }
}
