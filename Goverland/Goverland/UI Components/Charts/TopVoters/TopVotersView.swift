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
    @Binding private var filteringOption: DatesFiltetingOption
    @ObservedObject private var dataSource: TopVotersDataSource<Voter>
    private let showFilters: Bool
    private let horizontalPadding: CGFloat
    private let onShowAll: () -> Void

    init(filteringOption: Binding<DatesFiltetingOption>,
         dataSource: TopVotersDataSource<Voter>,
         showFilters: Bool,
         horizontalPadding: CGFloat = Constants.horizontalPadding,
         onShowAll: @escaping () -> Void)
    {
        _filteringOption = filteringOption
        _dataSource = ObservedObject(wrappedValue: dataSource)
        self.showFilters = showFilters
        self.horizontalPadding = horizontalPadding
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
            } else {
                _TopVotePowerVotersGraphView(filteringOption: $filteringOption, dataSource: dataSource, showFilters: showFilters, onShowAll: onShowAll)
            }
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, 16)
        .onAppear {
            if dataSource.topVoters?.isEmpty ?? true {
                dataSource.refresh()
            }
        }
    }
}

fileprivate struct _TopVotePowerVotersGraphView<Voter: VoterVotingPower>: View {
    @Binding var filteringOption: DatesFiltetingOption
    @ObservedObject var dataSource: TopVotersDataSource<Voter>
    let showFilters: Bool
    let onShowAll: () -> Void
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    private let barColors: [Color] = [.primaryDim, .yellow, .purple, .orange, .blue, .red, .teal, .green, .red, .cyan, .secondaryContainer]

    let columns: [GridItem] = {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return Array(repeating: .init(.flexible()), count: 3)
        default:
            return Array(repeating: .init(.flexible()), count: 5)
        }
    }()

    var body: some View {
        VStack {
            if showFilters {
                ChartFilters(selectedOption: $filteringOption)
                    .padding(.bottom, 16)
            }

            if dataSource.topVoters?.isEmpty ?? false {
                _MessageView(text: "No votes in the selected period")
            } else if dataSource.allVotersHaveSamePower {
                _MessageView(text: "All voters have the same voting power")
                _SeeAllButtonView(onShowAll: onShowAll)
                    .padding(.top, 16)
            } else {
                Chart(dataSource.top10votersGraphData) { voter in
                    BarMark(
                        x: .value("VotePower", voter.votingPower)
                    )
                    .foregroundStyle(by: .value("Name", voter.voter.usernameShort))
                    .clipShape(barShape(for: voter))
                }
                .frame(height: 32)
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
                                activeSheetManager.activeSheet = .publicProfileById(address.value)
                            }
                        }
                    }
                }

                _SeeAllButtonView(onShowAll: onShowAll)
                    .padding(.top, 16)
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

        return _RoundedCornersShape(corners: corners, radius: 5)
    }
}

fileprivate struct _MessageView: View {
    let text: String

    var body: some View {
        HStack {
            Text(text)
                .foregroundStyle(Color.textWhite)
            Spacer()
        }
        .padding(.horizontal, Constants.horizontalPadding)
    }
}

fileprivate struct _SeeAllButtonView: View {
    let onShowAll: () -> Void

    var body: some View {
        Text("See all")
            .frame(width: 124, height: 32, alignment: .center)
            .background(Capsule(style: .circular)
                .stroke(Color.secondaryContainer,style: StrokeStyle(lineWidth: 1)))
            .tint(.onSecondaryContainer)
            .font(.footnoteSemibold)
            .onTapGesture {
                onShowAll()
            }
    }
}

fileprivate struct _RoundedCornersShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
