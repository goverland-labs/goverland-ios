//
//  InboxDataService.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-05.
//

import SwiftUI
import Combine

class InboxDataService: ObservableObject {
    @Published var events: [InboxEvent] = []
    @Published var isLoading: Bool = false
    @Published var failedToLoadInitialData = false
    @Published var failedToLoadMore = false
    private var cancellables = Set<AnyCancellable>()

    private var total: Int?
    private var totalSkipped: Int?

    func refresh(withFilter filter: InboxFilter) {
        events = []
        isLoading = false
        failedToLoadInitialData = false
        failedToLoadMore = false
        cancellables = Set<AnyCancellable>()
        total = nil

        loadInitialData(filter: .all)
    }

    private func loadInitialData(filter: InboxFilter) {
        isLoading = true
        APIService.inboxEvents()
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
                self.totalSkipped = events.count - recognizedEvents.count
                self.total = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }

    func hasMore() -> Bool {
        guard let total = total, let totalSkipped = totalSkipped else { return true }
        return events.count < total - totalSkipped
    }

    func loadMore() {
        APIService.inboxEvents(offset: events.count)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadMore = true
                }
            } receiveValue: { [weak self] events, headers in
                guard let `self` = self else { return }
                let recognizedEvents = events.filter { $0.eventData != nil }
                self.events.append(contentsOf: recognizedEvents)
                self.totalSkipped! += events.count - recognizedEvents.count
                self.total = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }
}
