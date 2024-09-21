//
//  InboxDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-05.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation
import Combine

//enum InboxFilter: Int, FilterOptions {
//    case all = 0
//    case vote
//    case treasury
//
//    var localizedName: String {
//        switch self {
//        case .all:
//            return "All"
//        case .vote:
//            return "Vote"
//        case .treasury:
//            return "Treasury"
//        }
//    }
//}

class InboxDataSource: ObservableObject, Paginatable, Refreshable {
    @Published var events: [InboxEvent]? {
        didSet {
            if let events, let selectedEventIndex {
                if selectedEventIndex > events.count - 1 {
                    self.selectedEventIndex = events.count > 0 ? events.count - 1 : nil
                }
            }
        }
    }
    @Published var selectedEventIndex: Int?
//    @Published var filter: InboxFilter = .all
    @Published var isLoading: Bool = false
    @Published var failedToLoadInitialData = false
    @Published var failedToLoadMore = false
    private var cancellables = Set<AnyCancellable>()

    static let shared = InboxDataSource()

    private var total: Int?
    private var totalSkipped: Int?

    // subclassable
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(subscriptionDidToggle(_:)), name: .subscriptionDidToggle, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(eventUnarchived(_:)), name: .eventUnarchived, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(authTokenChanged(_:)), name: .authTokenChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(voteCasted(_:)), name: .voteCasted, object: nil)
    }

    func refresh() {
        refresh(nullifySelectedEventIndex: false)
    }

    func refresh(nullifySelectedEventIndex: Bool) {
        events = nil
        if nullifySelectedEventIndex {
            // refresh happens in different places
            // and often we need to keep the selected element index
            selectedEventIndex = nil
        }
        isLoading = false
        failedToLoadInitialData = false
        failedToLoadMore = false
        cancellables = Set<AnyCancellable>()
        total = nil
        totalSkipped = nil

        loadInitialData()
    }

    private func loadInitialData() {
        // Fool protection
        guard !SettingKeys.shared.authToken.isEmpty else { return }

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

                self.storeUnreadEventsCount(headers: headers)
            }
            .store(in: &cancellables)

        // to check user's archiving options
        if InboxSettingsDataSource.shared.notificationsSettings == nil {
            InboxSettingsDataSource.shared.refresh()
        }
    }

    func storeUnreadEventsCount(headers: HttpHeaders) {
        guard let unreadEvents = Utils.getUnreadEventsCount(from: headers) else { return }         
        SettingKeys.shared.unreadEvents = unreadEvents
    }

    func hasMore() -> Bool {
        guard let events = events,
                let total = total,
                let totalSkipped = totalSkipped else { return true }
        return events.count < total - totalSkipped
    }

    func loadMore() {
        APIService.inboxEvents(offset: events?.count ?? 0)
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
            } receiveValue: { [weak self] _, headers in
                guard let `self` = self else { return }
                if let index = self.events?.firstIndex(where: { $0.id == eventID }) {
                    self.events?[index].readAt = Date()
                    self.storeUnreadEventsCount(headers: headers)
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
            } receiveValue: { [weak self] _, headers in
                guard let `self` = self else { return }
                if let index = self.events?.firstIndex(where: { $0.id == eventID }) {
                    self.events?[index].readAt = nil
                    self.storeUnreadEventsCount(headers: headers)
                }
            }
            .store(in: &cancellables)
    }

    func markAllEventsRead() {
        guard let latestUpdatedEvent = events?.sorted(by: { $0.updatedAt > $1.updatedAt }).first else { return }
        APIService.markAllEventsRead(before: latestUpdatedEvent.updatedAt)
            .retry(3)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(_): break
                    // do nothing, error will be displayed to user if any
                }
            } receiveValue: { [weak self] _, _ in
                self?.refresh()
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
                showToast("Moved to Archive")
                guard let self else { return }
                if let index = self.events?.firstIndex(where: { $0.id == eventID }) {
                    self.events?[index].visible = false

                    if let event = self.events?[index], event.readAt == nil {
                        // fool protection
                        if SettingKeys.shared.unreadEvents > 0 {
                            SettingKeys.shared.unreadEvents -= 1
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }

    @objc func subscriptionDidToggle(_ notification: Notification) {
        refresh()
    }

    @objc func eventUnarchived(_ notification: Notification) {
        refresh()
    }

    @objc func authTokenChanged(_ notification: Notification) {
        let authToken = SettingKeys.shared.authToken
        logInfo("[App] Auth token changed to \(authToken)")
        if !authToken.isEmpty {
            refresh()
        } else {
            SettingKeys.shared.unreadEvents = 0
        }
    }

    @objc func voteCasted(_ notification: Notification) {
        guard let proposal = notification.object as? Proposal else { return }
        if let index = events?.firstIndex(where: { ($0.eventData as? Proposal)?.id == proposal.id }),
            let inboxSettings = InboxSettingsDataSource.shared.notificationsSettings, inboxSettings.archiveProposalAfterVote 
        {
            events?[index].visible = false
        }
    }
}
