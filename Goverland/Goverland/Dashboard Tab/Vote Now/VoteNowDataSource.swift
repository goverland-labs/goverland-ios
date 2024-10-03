//
//  VoteNowDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-09-23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class VoteNowDataSource: ObservableObject, Refreshable {
    let featured: Bool

    @Published var proposals: [Proposal]?
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()

    static let dashboard = VoteNowDataSource(featured: true)
    static let fullList = VoteNowDataSource(featured: false)

    private init(featured: Bool) {
        self.featured = featured
        NotificationCenter.default.addObserver(self, selector: #selector(voteCasted(_:)), name: .voteCasted, object: nil)
    }

    func refresh() {
        proposals = nil
        failedToLoadInitialData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()

        loadInitialData(featured: featured)
    }

    private func loadInitialData(featured: Bool) {
        guard !SettingKeys.shared.authToken.isEmpty else { return }
        
        isLoading = true
        APIService.voteNowProposals(featured: featured)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] proposals, headers in
                self?.proposals = proposals
            }
            .store(in: &cancellables)
    }

    @objc func voteCasted(_ notification: Notification) {
        refresh()
    }
}
