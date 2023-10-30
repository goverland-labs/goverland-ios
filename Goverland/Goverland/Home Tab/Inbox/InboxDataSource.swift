//
//  InboxDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-05.
//

import Foundation
import Combine

enum InboxFilter: Int, FilterOptions {
    case all = 0
    case vote
    case treasury

    var localizedName: String {
        switch self {
        case .all:
            return "All"
        case .vote:
            return "Vote"
        case .treasury:
            return "Treasury"
        }
    }
}

class InboxDataSource: ObservableObject, Paginatable, Refreshable {
    @Published var events: [InboxEvent]?
    @Published var filter: InboxFilter = .all
    @Published var isLoading: Bool = false
    @Published var failedToLoadInitialData = false
    @Published var failedToLoadMore = false
    private var cancellables = Set<AnyCancellable>()

    private var total: Int?
    private var totalSkipped: Int?

    var initialLoadingPublisher: AnyPublisher<([InboxEvent], HttpHeaders), APIError> {
        APIService.inboxEvents()
    }
    var loadMorePublisher: AnyPublisher<([InboxEvent], HttpHeaders), APIError> {
        APIService.inboxEvents(offset: events?.count ?? 0)
    }

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(subscriptionDidToggle(_:)), name: .subscriptionDidToggle, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(eventUnarchived(_:)), name: .eventUnarchived, object: nil)
    }

    func refresh() {
        events = nil
        isLoading = false
        failedToLoadInitialData = false
        failedToLoadMore = false
        cancellables = Set<AnyCancellable>()
        total = nil

        loadInitialData()
    }

    private func loadInitialData() {
        isLoading = true
        initialLoadingPublisher
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

                storeUnreadEventsCount(headers: headers)
            }
            .store(in: &cancellables)
    }

    func storeUnreadEventsCount(headers: HttpHeaders) {
        let unreadEvents = Utils.getUnreadEventsCount(from: headers) ?? 0
        SettingKeys.shared.unreadEvents = unreadEvents
    }

    func hasMore() -> Bool {
        guard let events = events,
                let total = total,
                let totalSkipped = totalSkipped else { return true }
        return events.count < total - totalSkipped
    }

    func loadMore() {
        loadMorePublisher
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadMore = true
                }
            } receiveValue: { [weak self] events, headers in
                guard let `self` = self else { return }
                let recognizedEvents = events.filter { $0.eventData != nil }
                self.events?.append(contentsOf: recognizedEvents)
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
        guard let event = events?.first(where: { $0.id == eventID }), event.readAt == nil else { return }
        APIService.markEventRead(eventID: eventID)
            .retry(3)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(_): break
                    // do nothing, error will be displayed to user if any
                }
            } receiveValue: { [weak self] _, _ in
                guard let `self` = self else { return }
                if let index = self.events?.firstIndex(where: { $0.id == eventID }) {
                    self.events?[index].readAt = Date()
                    SettingKeys.shared.unreadEvents -= 1
                }
            }
            .store(in: &cancellables)
    }
    
    func markAllEventsRead() {
        guard let latestEvent = events?.first else { return }
        APIService.markAllEventsRead(before: latestEvent.updatedAt)
            .retry(3)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(_): break
                    // do nothing, error will be displayed to user if any
                }
            } receiveValue: { [weak self] _, _ in
                guard let `self` = self else { return }
                SettingKeys.shared.unreadEvents = 0
                refresh()
            }
            .store(in: &cancellables)
    }

    func archive(eventID: UUID) {
        APIService.markEventArchived(eventID: eventID)
            .retry(3)
            .sink { competion in
                // do nothing, error will be displayed to user if any
                switch competion {
                case .finished: break
                case .failure(_): break
                }
            } receiveValue: { [weak self] _, _ in
                guard let `self` = self else { return }
                if let index = self.events?.firstIndex(where: { $0.id == eventID }) {
                    self.total? -= 1 // to properly handle load more
                    self.events?.remove(at: index)
                    SettingKeys.shared.unreadEvents -= 1
                }
            }
            .store(in: &cancellables)
    }

    @objc private func subscriptionDidToggle(_ notification: Notification) {
        refresh()
    }

    @objc private func eventUnarchived(_ notification: Notification) {
        refresh()
    }
}
