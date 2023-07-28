//
//  DaoInfoInsightsDaoView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-28.
//

import SwiftUI
import Charts

struct DaoInfoInsightsDaoView: View {
    let dao: Dao
    
    private let mockData = [
        (votersType: "Existed Voters", data: ChampionVoters.oldChampionVoters),
        (votersType: "New Voters", data: ChampionVoters.newChampionVoters)
    ]
    
    var body: some View {
        Chart {
            ForEach(mockData, id: \.votersType) { element in
                ForEach(element.data, id: \.date) {
                    BarMark (
                        x: .value("Date", $0.date),
                        y: .value("Voters in K", $0.voters)
                    )
                }
                .foregroundStyle(by: .value("Voters(type)", element.votersType))
                
            }
        }
        .padding(.horizontal)
    }
}

struct ChampionVoters: Identifiable {
    let id = UUID()
    let date: String
    let voters: Double
}

extension ChampionVoters {
    static let oldChampionVoters: [ChampionVoters] = [
        .init(date: "2023-01", voters: 11.4),
        .init(date: "2023-02", voters: 10.9),
        .init(date: "2023-03", voters: 9.9),
        .init(date: "2023-04", voters: 10.4),
        .init(date: "2023-05", voters: 11.4),
        .init(date: "2023-06", voters: 10.9),
        .init(date: "2023-07", voters: 9.9),
        .init(date: "2023-08", voters: 10.4)
    ]
    
    static let newChampionVoters: [ChampionVoters] = [
        .init(date: "2023-01", voters: 2.3),
        .init(date: "2023-02", voters: 1.1),
        .init(date: "2023-03", voters: 2.9),
        .init(date: "2023-04", voters: 2.4),
        .init(date: "2023-05", voters: 2.3),
        .init(date: "2023-06", voters: 1.1),
        .init(date: "2023-07", voters: 2.9),
        .init(date: "2023-08", voters: 2.4)
    ]
    
}
            
        

struct DaoInfoInsightsDaoView_Previews: PreviewProvider {
    static var previews: some View {
        DaoInfoInsightsDaoView(dao: .aave)
    }
}
