//
//  InboxDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-05.
//

import SwiftUI
import Combine

class InboxDataSource: ObservableObject, Paginatable {
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
        APIService.inboxEvents(limit: 100)
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

                // TODO: implement properly
                let unreadEvents = self.events.filter { $0.readAt == nil }.count
                SettingKeys.shared.unreadEvents = unreadEvents
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

    func retryLoadMore() {
        // This will trigger view update cycle that will trigger `loadMore` function
        self.failedToLoadMore = false
    }

    func markRead(eventID: UUID) {
        guard let event = events.first(where: { $0.id == eventID }), event.readAt == nil else { return }
        APIService.markEventRead(eventID: eventID)
            .retry(3)
            .sink { competion in
                switch competion {
                case .finished: break
                case .failure(_): break
                    // do nothing, error will be displayed to user if any
                }
            } receiveValue: { [weak self] _, _ in
                guard let `self` = self else { return }
                if let index = self.events.firstIndex(where: { $0.id == eventID }) {
                    self.events[index].readAt = Date()
                    SettingKeys.shared.unreadEvents -= 1
                }
            }
            .store(in: &cancellables)
    }

    func archive(eventID: UUID) {
        APIService.markEventArchived(eventID: eventID)
            .retry(3)
            .sink { [weak self] competion in
                switch competion {
                case .finished: break
                case .failure(_):
                    // do nothing, error will be displayed to user if any

                    // TODO: remove one backend is ready
                    guard let `self` = self else { return }
                    if let index = self.events.firstIndex(where: { $0.id == eventID }) {
                        self.events.remove(at: index)
                    }
                }
            } receiveValue: { [weak self] _, _ in
                guard let `self` = self else { return }
                if let index = self.events.firstIndex(where: { $0.id == eventID }) {
                    self.events.remove(at: index)
                }
            }
            .store(in: &cancellables)
    }
}
