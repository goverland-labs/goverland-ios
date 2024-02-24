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
    private let daoID: UUID
    @StateObject private var dataSource: TopVotersDataSource
    @State private var showAllVotes = false
    
    init(dao: Dao) {
        let dataSource = TopVotersDataSource(dao: dao)
        _dataSource = StateObject(wrappedValue: dataSource)
        self.daoID = dao.id
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Top 10 voters by average VP")
                    .font(.title3Semibold)
                    .foregroundColor(.textWhite)
                Spacer()
            }
            
            if dataSource.failedToLoadInitialData {
                RefreshIcon {
                    dataSource.refresh()
                }
                .frame(height: 120)
            } else if dataSource.topVotePowerVoters.isEmpty {
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
            if dataSource.topVotePowerVoters.isEmpty {
                dataSource.refresh()
            }
        }
        .sheet(isPresented: $showAllVotes) {
            NavigationStack {
                AllVotersListView(daoID: daoID)
            }
            .overlay (
                ToastView()
            )
        }
    }
}

fileprivate struct TopVotePowerVotersGraphView: View {
    @StateObject var dataSource: TopVotersDataSource
    private let barColors: [Color] = [.primaryDim, .yellow, .purple, .orange, .blue, .red, .teal, .green, .red, .cyan, .secondaryContainer]
    
    var body: some View {
        VStack {
            Chart(dataSource.top10votersGraphData) { voter in
                BarMark(
                    x: .value("VotePower", voter.voterPower)
                )
                .foregroundStyle(by: .value("Name", voter.name.short))
                .clipShape(barShape(for: voter))
            }
        }
        .chartXAxis(.hidden)
        .chartLegend(spacing: 10)
        .chartXScale(domain: 0...(dataSource.totalVotingPower ?? 0)) // expands the bar to fill the entire width of the view
        .chartForegroundStyleScale(domain: dataSource.top10votersGraphData.compactMap({ voter in voter.name.short}),
                                   range: barColors) // assigns colors to the segments of the bar
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
