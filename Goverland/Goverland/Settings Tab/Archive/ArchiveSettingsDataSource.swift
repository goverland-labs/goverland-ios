//
//  ArchiveSettingsDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-09-23.
//

import Foundation
import Combine


class ArchiveSettingsDataSource: ObservableObject, Paginatable, Refreshable {
    @Published var archives: [InboxEvent]?
    @Published var isLoading: Bool = false
    @Published var failedToLoadInitialData = false
    @Published var failedToLoadMore = false
    private var cancellables = Set<AnyCancellable>()
    private var total: Int?

    var initialLoadingPublisher: AnyPublisher<([InboxEvent], HttpHeaders), APIError> {
        APIService.archiveEvents()
    }
    var loadMorePublisher: AnyPublisher<([InboxEvent], HttpHeaders), APIError> {
        APIService.archiveEvents(offset: archives?.count ?? 0)
    }

    init() {
        refresh()
    }

    func refresh() {
        archives = nil
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
                self.archives = archives
            }
            .store(in: &cancellables)
    }

    func hasMore() -> Bool {
        guard let archives = archives,
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
                self.archives?.append(contentsOf: archives)
                self.total = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }

    func retryLoadMore() {
        // This will trigger view update cycle that will trigger `loadMore` function
        self.failedToLoadMore = false
    }

//    func unarchive(eventID: UUID) {
//        APIService.markEventUnarchived(eventID: eventID)
//            .retry(3)
//            .sink { [weak self] completion in
//                switch completion {
//                case .finished: break
//                case .failure(_):
//                    // do nothing, error will be displayed to user if any
//
//                    // TODO: remove once backend is ready
//                    guard let `self` = self else { return }
//                    if let index = self.events?.firstIndex(where: { $0.id == eventID }) {
//                        self.total? -= 1 // to properly handle load more
//                        self.events?.remove(at: index)
//                    }
//                }
//            } receiveValue: { [weak self] _, _ in
//                guard let `self` = self else { return }
//                if let index = self.events?.firstIndex(where: { $0.id == eventID }) {
//                    self.total? -= 1 // to properly handle load more
//                    self.events?.remove(at: index)
//                }
//            }
//            .store(in: &cancellables)
//    }

    @objc private func subscriptionDidToggle(_ notification: Notification) {
        refresh()
    }
}

