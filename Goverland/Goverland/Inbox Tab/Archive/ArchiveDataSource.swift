//
//  ArchiveDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-09-23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation
import Combine


class ArchiveDataSource: ObservableObject, Paginatable, Refreshable {
    @Published var events: [InboxEvent]?
    @Published var isLoading: Bool = false
    @Published var failedToLoadInitialData = false
    @Published var failedToLoadMore = false
    private var cancellables = Set<AnyCancellable>()
    private var total: Int?

    var initialLoadingPublisher: AnyPublisher<([InboxEvent], HttpHeaders), APIError> {
        APIService.archivedEvents()
    }
    var loadMorePublisher: AnyPublisher<([InboxEvent], HttpHeaders), APIError> {
        APIService.archivedEvents(offset: events?.count ?? 0)
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
            } receiveValue: { [weak self] archives, headers in
                guard let `self` = self else { return }
                self.events = archives
            }
            .store(in: &cancellables)
    }

    func hasMore() -> Bool {
        guard let archives = events,
                let total = total else { return true }
        return archives.count < total
    }

    func loadMore() {
        loadMorePublisher
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadMore = true
                }
            } receiveValue: { [weak self] archives, headers in
                guard let `self` = self else { return }
                self.events?.append(contentsOf: archives)
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
            .sink { competion in
                switch competion {
                case .finished: break
                case .failure(_): break
                    // do nothing, error will be displayed to user if any
                }
            } receiveValue: { [weak self] _, _ in
                guard let `self` = self else { return }
                if let index = self.events?.firstIndex(where: { $0.id == eventID }) {
                    self.events?[index].readAt = Date()
                }
            }
            .store(in: &cancellables)
    }

    func markUnread(eventID: UUID) {
        guard let event = events?.first(where: { $0.id == eventID }), event.readAt != nil else { return }
        APIService.markEventUnread(eventID: eventID)
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
                    self.events?[index].readAt = nil
                }
            }
            .store(in: &cancellables)
    }

    func unarchive(eventID: UUID) {
        APIService.markEventUnarchived(eventID: eventID)
            .retry(3)
            .sink { completion in
                switch completion {
                case .finished: 
                    NotificationCenter.default.post(name: .eventUnarchived, object: nil)
                case .failure(_):
                    // do nothing, error will be displayed to user if any
                    break
                }
            } receiveValue: { [weak self] _, _ in
                showToast("Moved to Inbox")
                guard let `self` = self else { return }
                if let index = self.events?.firstIndex(where: { $0.id == eventID }) {
                    self.total? -= 1 // to properly handle load more
                    self.events?.remove(at: index)
                }
            }
            .store(in: &cancellables)
    }
}
