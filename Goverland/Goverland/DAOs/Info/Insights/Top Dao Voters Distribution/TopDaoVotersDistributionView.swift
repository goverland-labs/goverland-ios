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
                            if let bin = dataSource.bins.first(where: { String($0.range.lowerBound) == selectedBin }),
                                let total = dataSource.vps?.count
                            {
                                let voters = bin.count
                                let percentage = Utils.percentage(of: voters, in: total)
                                AnnotationView(firstPlaceholderValue: String(voters),
                                               firstPlaceholderTitle: voters == 1 ? "Voter (\(percentage))" : "Voters (\(percentage))",
                                               secondPlaceholderValue: nil,
                                               secondPlaceholderTitle: "aVP is between \(bin.range.lowerBound)\nand \(bin.range.upperBound) (not inclusive)",
                                               description: nil)
                            }
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
