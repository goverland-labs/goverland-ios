//
//  TopDaoVotersDistributionView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 16.09.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import Charts

struct TopDaoVotersDistributionView: View {
    @StateObject private var dataSource: TopDaoVotersDistributionDataSource
    @Binding private var datesFilteringOption: DatesFiltetingOption
    @State private var distributionFilteringOption: DistributionFilteringOption = .square

    init(dao: Dao,
         datesFilteringOption: Binding<DatesFiltetingOption>,
         distributionFilteringOption: DistributionFilteringOption = .square)
    {
        let dataSource = TopDaoVotersDistributionDataSource(dao: dao,
                                                            datesFilteringOption: datesFilteringOption.wrappedValue,
                                                            distributionFilteringOption: distributionFilteringOption)
        _datesFilteringOption = datesFilteringOption
        _distributionFilteringOption = State(wrappedValue: distributionFilteringOption)
        _dataSource = StateObject(wrappedValue: dataSource)
    }

    var body: some View {
        GraphView(header: "Average VP distribution",
                  subheader: nil,
                  isLoading: dataSource.isLoading,
                  failedToLoadInitialData: dataSource.failedToLoadInitialData,
                  height: 350,
                  onRefresh: dataSource.refresh)
        {
            _TopDaoVotersDistributionChart(dataSource: dataSource,
                                           distributionFilteringOption: $distributionFilteringOption)
        }
        .onAppear() {
            if dataSource.vps?.isEmpty ?? true {
                dataSource.refresh()
            }
        }
        .onChange(of: datesFilteringOption) { _, newValue in
            withAnimation {
                dataSource.datesFilteringOption = newValue
            }
        }
        .onChange(of: distributionFilteringOption) { _, newValue in
            withAnimation {
                dataSource.distributionFilteringOption = newValue
            }
        }
    }
}

fileprivate struct _TopDaoVotersDistributionChart: GraphViewContent {
    @ObservedObject var dataSource: TopDaoVotersDistributionDataSource
    @Binding var distributionFilteringOption: DistributionFilteringOption
    @State private var selectedBin: String?

    var xLabel: String {
        switch distributionFilteringOption {
        case .square:
            "Voting Power Range (Square Root)"
        case .log:
            "Voting Power Range (Log)"
        }
    }

    var body: some View {
        VStack {
            ChartFilters(selectedOption: $distributionFilteringOption)
                .padding(.leading, Constants.horizontalPadding)

            Chart {
                ForEach(dataSource.bins.indices, id: \.self) { index in
                    if index < dataSource.bins.count {
                        // it crashes when chaning date filtering option, doesn't refresh on time
                        let bin = dataSource.bins[index]
                        BarMark (
                            x: .value("Range", "\(bin.range.lowerBound)"),
                            y: .value("Voters", bin.count)
                        )
                        .foregroundStyle(Color.primaryDim)
                    }
                }

                if let selectedBin {
                    RuleMark(x: .value("Range", selectedBin))
                        .foregroundStyle(Color.textWhite)
                        .lineStyle(.init(lineWidth: 1, dash: [2]))
                        .annotation(
                            position: annotationPositionForBin(bin: selectedBin),
                            alignment: .center, spacing: 4
                        ) {
                            _AnnotationView(binLowerBound: selectedBin, dataSource: dataSource)
                        }
                }
            }
            .padding()
            .chartXAxis {
                AxisMarks(values: dataSource.xValues) { value in
                    AxisValueLabel()
                    AxisGridLine()
                }
            }
            .chartXAxisLabel(xLabel)
//            .chartYAxisLabel("Number of Voters")
            .chartForegroundStyleScale([
                "Voters": Color.primaryDim
            ])
            .chartSelected_X_String($selectedBin)
        }
    }

    private func annotationPositionForBin(bin: String) -> AnnotationPosition {
        let bins = dataSource.bins.map { "\($0.range.lowerBound)" }
        guard let binIndex = bins.firstIndex(of: bin) else {
            return .trailing
        }
        return binIndex < bins.count / 2 ? .trailing : .leading
    }
}

fileprivate struct _AnnotationView: View {
    let binLowerBound: String
    let dataSource: TopDaoVotersDistributionDataSource

    var bin: TopDaoVotersDistributionDataSource.Bin {
        dataSource.bins.first { String($0.range.lowerBound) == binLowerBound } ?? (range: 1..<2, count: 1)
    }

    var voters: Int {
        bin.count
    }

    var total: Int {
        dataSource.vps?.count ?? 1
    }

    var percentage: String {
        Utils.percentage(of: voters, in: total)
    }

    var binDescription: String { """
aVP is between \(bin.range.lowerBound)
and \(bin.range.upperBound) (not inclusive)"
""" }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                HStack(alignment: .bottom, spacing: 4) {
                    Text(String(voters))
                        .font(.title3Regular)
                        .foregroundStyle(Color.textWhite)
                    Text(voters == 1 ? "Voter (\(percentage))" : "Voters (\(percentage))")
                        .font(.subheadlineRegular)
                        .foregroundStyle(Color.textWhite60)
                        .padding(.bottom, 2)
                }
                Spacer()
            }
            HStack {
                HStack(spacing: 4) {
                    Text(binDescription)
                        .font(.subheadlineRegular)
                        .foregroundStyle(Color.textWhite60)
                }
                Spacer()
            }
        }
        .padding(8)
        .background(Color.containerBright)
        .cornerRadius(10)
    }
}
