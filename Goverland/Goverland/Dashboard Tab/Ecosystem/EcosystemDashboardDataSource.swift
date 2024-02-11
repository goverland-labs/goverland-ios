//
//  EcosystemDashboardDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-12.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI
import Combine
import SwiftDate

class EcosystemDashboardDataSource: ObservableObject {
    @Published var periodInDays = 7
    @Published var charts: EcosystemChart?
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    private var cashCharts7Days: EcosystemChart? = nil
    private var cashCharts30Days: EcosystemChart? = nil
    private var cachedDate = Date.now

    static let shared = EcosystemDashboardDataSource()
    private init() {}

    private func formattedDataString(current: Int?, previous: Int?) -> String {
        guard let current = current else {
            return ""
        }
        if let previous = previous {
            let percent = Utils.percentage(of: current - previous, in: previous)
            return current > previous ? "+\(percent)" : percent
        }
        return Utils.formattedNumber(Double(current))
    }

    private func metadataColor(current: Int?, previous: Int?) -> Color {
        guard let current = current, let previous = previous else {
            return Color.textWhite60
        }
        return current > previous ? Color.primaryDim : Color.dangerText
    }
    
    // MARK: - DAOs Chart Data
    var dataActiveDaos: String {
        return formattedDataString(current: charts?.daos.current, previous: nil)
    }

    var metadataActiveDaos: String {
        return formattedDataString(current: charts?.daos.current, previous: charts?.daos.previous)
    }

    var metadataColorForActiveDaos: Color {
        return metadataColor(current: charts?.daos.current, previous: charts?.daos.previous)
    }

    // MARK: - Voters Chart Data
    var dataActiveVoters: String {
        return formattedDataString(current: charts?.voters.current, previous: nil)
    }

    var metadataActiveVoters: String {
        return formattedDataString(current: charts?.voters.current, previous: charts?.voters.previous)
    }

    var metadataColorForActiveVoters: Color {
        return metadataColor(current: charts?.voters.current, previous: charts?.voters.previous)
    }

    // MARK: - Proposals Chart Data
    var dataCreatedProposals: String {
        return formattedDataString(current: charts?.proposals.current, previous: nil)
    }

    var metadataCreatedProposals: String {
        return formattedDataString(current: charts?.proposals.current, previous: charts?.proposals.previous)
    }

    var metadataColorForCreatedProposals: Color {
        return metadataColor(current: charts?.proposals.current, previous: charts?.proposals.previous)
    }

    // MARK: - Votes Chart Data
    var dataTotalVotes: String {
        return formattedDataString(current: charts?.votes.current, previous: nil)
    }

    var metadataTotalVotes: String {
        return formattedDataString(current: charts?.votes.current, previous: charts?.votes.previous)
    }

    var metadataColorForTotalVotes: Color {
        return metadataColor(current: charts?.votes.current, previous: charts?.votes.previous)
    }

    func refreshWithCache() {
        if periodInDays == 7 {
            charts = cashCharts7Days
        } else if periodInDays == 30 {
            charts = cashCharts30Days
        }

        if charts == nil || cachedDate < .now - 1.days {
            refresh()
        }
    }

    func refresh() {
        failedToLoadInitialData = false
        isLoading = true
        cancellables = Set<AnyCancellable>()
        loadInitialData()
    }

    private func loadInitialData() {
        APIService.ecosystemCharts(days: periodInDays)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] data, headers in
                self?.charts = data
                if self?.periodInDays == 7 {
                    self?.cashCharts7Days = data
                } else if self?.periodInDays == 30 {
                    self?.cashCharts30Days = data
                }
                self?.cachedDate = .now
            }
            .store(in: &cancellables)
    }
}
