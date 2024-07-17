//
//  ProfileVotesDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 05.02.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class ProfileVotesDataSource: ObservableObject, Refreshable, Paginatable {
    @Published var votedProposals: [Proposal]?
    @Published var isLoading: Bool = false
    @Published var failedToLoadInitialData = false
    @Published var failedToLoadMore = false
    private var cancellables = Set<AnyCancellable>()

    static let shared = ProfileVotesDataSource()

    private(set) var total: Int?

    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(authTokenChanged(_:)), name: .authTokenChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(voteCasted(_:)), name: .voteCasted, object: nil)
    }

    @objc func authTokenChanged(_ notification: Notification) {
        refresh()
    }

    @objc func voteCasted(_ notification: Notification) {
        refresh()
    }

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
        APIService.profileVotes()
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] proposals, headers in
                guard let `self` = self else { return }
                self.votedProposals = proposals
                self.total = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }

    func hasMore() -> Bool {
        guard let votedProposals, let total = total else { return true }
        return votedProposals.count < total
    }

    func loadMore() {
        APIService.profileVotes(offset: votedProposals?.count ?? 0)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadMore = true
                }
            } receiveValue: { [weak self] proposals, headers in
                guard let `self` = self else { return }
                self.votedProposals?.append(contentsOf: proposals)
                self.total = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }

    func retryLoadMore() {
        // This will trigger view update cycle that will trigger `loadMore` function
        self.failedToLoadMore = false
    }
}
