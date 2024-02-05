//
//  ProfileVotesDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 05.02.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class ProfileVotesDataSource: ObservableObject, Refreshable {
    @Published var votedProposals: [Proposal]?
    @Published var isLoading: Bool = false
    @Published var failedToLoadInitialData = false
    @Published var failedToLoadMore = false
    private var cancellables = Set<AnyCancellable>()

    static let shared = ProfileVotesDataSource()

    private var total: Int?

    private init() {}

    func refresh() {
        votedProposals = nil
        isLoading = false
        failedToLoadInitialData = false
        failedToLoadMore = false
        cancellables = Set<AnyCancellable>()
        total = nil

        loadInitialData()
    }

    private func loadInitialData() {        
        guard !SettingKeys.shared.authToken.isEmpty else { return }

        isLoading = true
//        initialLoadingPublisher
//            .sink { [weak self] completion in
//                self?.isLoading = false
//                switch completion {
//                case .finished: break
//                case .failure(_): self?.failedToLoadInitialData = true
//                }
//            } receiveValue: { [weak self] events, headers in
//                guard let `self` = self else { return }
//                let recognizedEvents = events.filter { $0.eventData != nil }
//                self.events = recognizedEvents
//                self.totalSkipped = events.count - recognizedEvents.count
//                self.total = Utils.getTotal(from: headers)
//
//                storeUnreadEventsCount(headers: headers)
//            }
//            .store(in: &cancellables)
    }
}
