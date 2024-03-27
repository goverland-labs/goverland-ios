//
//  MonthlyNewProposalsDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-30.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import Combine

class MonthlyNewProposalsDataSource: ObservableObject, Refreshable {
    private let daoID: UUID

    @Published var selectedFilteringOption: DatesFiltetingOption = .oneYear {
        didSet {
            refresh(invalidateCache: false)
        }
    }

    @Published var monthlyNewProposals: [MonthlyNewProposals] = []
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()

    var chartData: [(proposalsType: String, data: [ProposalsGraphData])] {
        [(proposalsType: "New proposals", data: getNewProposals()),
         (proposalsType: "Spam proposals", data: getSpamProposals())]
    }

    private var cache: [DatesFiltetingOption: [MonthlyNewProposals]] = [:]

    init(daoID: UUID) {
        self.daoID = daoID
    }
    
    convenience init(dao: Dao) {
        self.init(daoID: dao.id)
    }

    func refresh() {
        refresh(invalidateCache: true)
    }

    private func refresh(invalidateCache: Bool) {
        if let cachedData = cache[selectedFilteringOption], !invalidateCache {
            monthlyNewProposals = cachedData
            return
        }

        if invalidateCache {
            cache = [:]
        }

        monthlyNewProposals = []
        failedToLoadInitialData = false
        isLoading = true
        cancellables = Set<AnyCancellable>()
        loadData()
    }
    
    private func loadData() {
        APIService.monthlyNewProposals(id: daoID, filteringOption: selectedFilteringOption)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] data, headers in
                guard let self else { return }
                self.monthlyNewProposals = data
                self.cache[selectedFilteringOption] = data
            }
            .store(in: &cancellables)
    }

    struct ProposalsGraphData: Identifiable {
        let id = UUID()
        let date: Date
        let proposals: Int
    }

    private func getNewProposals() -> [ProposalsGraphData] {
        monthlyNewProposals.map { ProposalsGraphData(date: $0.date, proposals: $0.count - $0.spamCount) }
    }

    private func getSpamProposals() -> [ProposalsGraphData] {
        monthlyNewProposals.map { ProposalsGraphData(date: $0.date, proposals: $0.spamCount) }
    }

    func newProposalsCount(date: Date) -> String {
        let date = selectedFilteringOption == .oneMonth ?
            Utils.formatDateToStartOfDay(date) :
            Utils.formatDateToStartOfMonth(date)
        if let data = monthlyNewProposals.first(where: { $0.date == date }) {
            return Utils.decimalNumber(from: data.count - data.spamCount)
        }
        return "0"
    }

    func spamProposalsCount(date: Date) -> String {
        let date = Utils.formatDateToStartOfMonth(date)
        if let data = monthlyNewProposals.first(where: { $0.date == date }) {
            return Utils.decimalNumber(from: data.spamCount)
        }
        return "0"
    }
}
