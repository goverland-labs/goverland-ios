//
//  DaoInfoEventsDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.07.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation
import Combine

class DaoInfoEventsDataSource: ObservableObject, Paginatable, Refreshable {
    let daoID: UUID

    @Published var events: [InboxEvent]?
    @Published var isLoading: Bool = false
    @Published var failedToLoadInitialData = false
    @Published var failedToLoadMore = false
    private var cancellables = Set<AnyCancellable>()

    private var total: Int?
    private var loaded = 0
    private let paginationCount = ConfigurationManager.defaultPaginationCount

    init(daoID: UUID) {
        self.daoID = daoID
        NotificationCenter.default.addObserver(self, selector: #selector(voteCasted(_:)), name: .voteCasted, object: nil)
    }

    func refresh() {
        events = nil
        isLoading = false
        failedToLoadInitialData = false
        failedToLoadMore = false
        cancellables = Set<AnyCancellable>()
        total = nil
        loaded = 0

        loadInitialData()
    }

    private func loadInitialData() {
        isLoading = true
        APIService.daoEvents(daoID: daoID, limit: paginationCount)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] events, headers in
                guard let `self` = self else { return }
                let recognizedEvents = events.filter { $0.eventData != nil }
                self.events = recognizedEvents
                self.total = Utils.getTotal(from: headers)
                self.loaded = paginationCount
            }
            .store(in: &cancellables)
    }

    func hasMore() -> Bool {
        guard let total = total else { return true }
        return loaded < total
    }

    func loadMore() {
        APIService.daoEvents(daoID: daoID, offset: loaded, limit: paginationCount)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadMore = true
                }
            } receiveValue: { [weak self] events, headers in
                guard let self else { return }
                let recognizedEvents = events.filter { $0.eventData != nil }
                self.events?.append(contentsOf: recognizedEvents)
                self.total = Utils.getTotal(from: headers)
                self.loaded += paginationCount
            }
            .store(in: &cancellables)
    }

    func retryLoadMore() {
        // This will trigger view update cycle that will trigger `loadMore` function
        self.failedToLoadMore = false
    }

    @objc func voteCasted(_ notification: Notification) {
        // Andrey (22.08.2024): I have tested and it works well when voting from a paginated
        // proposal. Refresh doesn't break the presented view.
        refresh()
    }
}
