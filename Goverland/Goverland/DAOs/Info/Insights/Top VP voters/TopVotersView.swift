//
//  TopVotersView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-07.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI
import Charts

struct TopVotersView: View {
    private let dao: Dao
    @StateObject private var dataSource: TopVotersDataSource
    @State private var showAllVotes = false
    
    init(dao: Dao) {
        let dataSource = TopVotersDataSource(dao: dao)
        _dataSource = StateObject(wrappedValue: dataSource)
        self.dao = dao
    }
    
    var body: some View {
        GraphHeaderView(header: "Top 10 voters by average VP",
                        subheader: "Average voting power is calculated based on the last six months of user activity.",
                        tooltipSide: .topLeft)
        VStack {
            if dataSource.failedToLoadInitialData {
                RefreshIcon {
                    dataSource.refresh()
                }
                .frame(height: 120)
            } else if dataSource.topVoters.isEmpty {
                // It should not happen that a response from backend will be an empty array.
                // It would mean that a DAO has no voters or our analytics miss data.
                // As this is a very rare case, we will not introduce an additional `loading` state,
                // but consider it loading when the result array is empty (default value)
                ProgressView()
                    .foregroundColor(.textWhite20)
                    .controlSize(.regular)
                    .frame(height: 120)
            } else {
                VStack {
                    TopVotePowerVotersGraphView(dataSource: dataSource)
                    Text("Show all voters")
                        .frame(width: 150, height: 35, alignment: .center)
                        .background(Capsule(style: .circular)
                            .stroke(Color.secondaryContainer,style: StrokeStyle(lineWidth: 2)))
                        .tint(.onSecondaryContainer)
                        .font(.footnoteSemibold)
                        .onTapGesture {
                            showAllVotes = true
                        }
                }
            }
        }
        .padding()
        .padding(.bottom)
        .onAppear {
            if dataSource.topVoters.isEmpty {
                dataSource.refresh()
            }
        }
        .sheet(isPresented: $showAllVotes) {
            NavigationStack {
                AllVotersListView(dao: dao)
            }
            .overlay (
                ToastView()
            )
        }
    }
}

fileprivate struct TopVotePowerVotersGraphView: View {
    @ObservedObject var dataSource: TopVotersDataSource
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
            Chart(dataSource.top10votersGraphData) { voter in
                BarMark(
                    x: .value("VotePower", voter.votingPower)
                )
                .foregroundStyle(by: .value("Name", voter.name.short))
                .clipShape(barShape(for: voter))
            }
            .frame(height: 30)
            .chartXAxis(.hidden)
            .chartLegend(.hidden)
            .chartXScale(domain: 0...(dataSource.totalVotingPower ?? 0)) // expands the bar to fill the entire width of the view
            .chartForegroundStyleScale(domain: dataSource.top10votersGraphData.compactMap({ voter in voter.name.short}),
                                       range: barColors) // assigns colors to the segments of the bar
            
            // Custom Chart Legend
            LazyVGrid(columns: columns, alignment: .leading, spacing: 5) {
                ForEach((0...10), id: \.self) { index in
                    NavigationLink(destination: UserInfoView(voter: dataSource.top10votersGraphData[index])) {
                        HStack {
                            Circle()
                                .fill(barColors[index])
                                .frame(width: 8, height: 8)
                            Text(dataSource.top10votersGraphData[index].name.short)
                                .font(.caption2)
                                .foregroundColor(.textWhite60)
                        }
                    }
                }
            }
        }
    }
    
    private func barShape(for voter: TopVoter) -> some Shape {
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
