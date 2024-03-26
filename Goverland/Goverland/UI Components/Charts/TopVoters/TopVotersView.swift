//
//  TopVotersView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 26.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import Charts

struct TopVotersView<Voter: VoterVotingPower>: View {
    @ObservedObject private var dataSource: TopVotersDataSource<Voter>
    private let showFilters: Bool
    private var onShowAll: () -> Void

    init(dataSource: TopVotersDataSource<Voter>,
         showFilters: Bool,
         onShowAll: @escaping () -> Void)
    {
        _dataSource = ObservedObject(wrappedValue: dataSource)
        self.showFilters = showFilters
        self.onShowAll = onShowAll
    }

    var body: some View {
        VStack {
            if dataSource.failedToLoadInitialData {
                RefreshIcon {
                    dataSource.refresh()
                }
                .frame(height: 120)
            } else if dataSource.topVoters == nil { // Loading
                ProgressView()
                    .foregroundColor(.textWhite20)
                    .controlSize(.regular)
                    .frame(height: 120)
            } else if dataSource.topVoters?.isEmpty ?? false {
                Text("No votes in the selected period")
                    .foregroundStyle(Color.textWhite)
            } else {
                VStack(spacing: 16) {
                    TopVotePowerVotersGraphView(dataSource: dataSource, showFilters: showFilters)
                    Text("Show all voters")
                        .frame(width: 150, height: 35, alignment: .center)
                        .background(Capsule(style: .circular)
                            .stroke(Color.secondaryContainer,style: StrokeStyle(lineWidth: 2)))
                        .tint(.onSecondaryContainer)
                        .font(.footnoteSemibold)
                        .onTapGesture {
                            onShowAll()
                        }
                }
            }
        }
        .padding()
        .padding(.bottom)
        .onAppear {
            if dataSource.topVoters?.isEmpty ?? true {
                dataSource.refresh()
            }
        }
    }
}

fileprivate struct TopVotePowerVotersGraphView<Voter: VoterVotingPower>: View {
    @ObservedObject var dataSource: TopVotersDataSource<Voter>
    let showFilters: Bool
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    private let barColors: [Color] = [.primaryDim, .yellow, .purple, .orange, .blue, .red, .teal, .green, .red, .cyan, .secondaryContainer]

    let columns: [GridItem] = {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return Array(repeating: .init(.flexible()), count: 5)
        } else {
            return Array(repeating: .init(.flexible()), count: 3)
        }
    }()

    var body: some View {
        VStack {
            if showFilters {
                ChartFilters(selectedOption: $dataSource.selectedFilteringOption)
                    .padding(.bottom, 16)
            }

            Chart(dataSource.top10votersGraphData) { voter in
                BarMark(
                    x: .value("VotePower", voter.votingPower)
                )
                .foregroundStyle(by: .value("Name", voter.voter.usernameShort))
                .clipShape(barShape(for: voter))
            }
            .frame(height: 30)
            .chartXAxis(.hidden)
            .chartLegend(.hidden)
            .chartXScale(domain: 0...(dataSource.totalVotingPower ?? 0)) // expands the bar to fill the entire width of the view
            .chartForegroundStyleScale(domain: dataSource.top10votersGraphData.compactMap({ voter in voter.voter.usernameShort}),
                                       range: barColors) // assigns colors to the segments of the bar

            // Custom Chart Legend
            LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                let count = dataSource.top10votersGraphData.count
                ForEach((0..<min(11, count)), id: \.self) { index in
                    HStack {
                        Circle()
                            .fill(barColors[index])
                            .frame(width: 8, height: 8)
                        Text(dataSource.top10votersGraphData[index].voter.usernameShort)
                            .font(.caption2)
                            .foregroundColor(.textWhite60)
                    }
                    .onTapGesture {
                        // Skip tapping on `Other`
                        if index < 10 {
                            let address = dataSource.top10votersGraphData[index].voter.address
                            activeSheetManager.activeSheet = .publicProfile(address)
                        }
                    }
                }
            }
        }
    }

    private func barShape(for voter: Voter) -> some Shape {
        var corners: UIRectCorner = []

        if let firstVoter = dataSource.top10votersGraphData.first,
           let lastVoter = dataSource.top10votersGraphData.last {
            if voter.id == firstVoter.id {
                corners = [.topLeft, .bottomLeft]
            } else if voter.id == lastVoter.id {
                corners = [.topRight, .bottomRight]
            }
        }

        return RoundedCornersShape(corners: corners, radius: 5)
    }
}

fileprivate struct RoundedCornersShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
