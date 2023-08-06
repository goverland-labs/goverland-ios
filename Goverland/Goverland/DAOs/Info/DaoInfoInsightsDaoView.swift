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
    // for Chart bars animation
    let mockChartData = [
        (votersType: "Existed Voters", data: oldChampionVoters),
        (votersType: "New Voters", data: newChampionVoters)
    ]
    
    @State var votersChartData = oldChampionVoters
    @State var rawSelectedDate: Date?
    
    var body: some View {
        VStack {
            Chart {
                ForEach(mockChartData, id: \.votersType) { element in
                    ForEach(element.data, id: \.date) { data in
                        BarMark (
                            x: .value("Date", data.date, unit: .month),
                            y: .value("Voters in K", data.voters)
                        )
                        .annotation {
                            if data.voters == 0 {
                                Text("0")
                                    .foregroundColor(.textWhite40)
                                    .font(.сaption2Regular)
                            }
                        }
                        .foregroundStyle(by: .value("Voters(type)", element.votersType))
                        .foregroundStyle(Color.chartBar)
                    }
                    
                }
                
            }
            .frame(height: 200)
            .padding(.horizontal)
            
            .chartForegroundStyleScale([
                "Existed Voters": Color.chartBar, "New Voters": Color.primary
            ])
            
            
            
            
            
            Chart {
                ForEach(votersChartData) { element in
                    BarMark (
                        x: .value("Date", element.date, unit: .month),
                        y: .value("Voters in K", element.voters)
                    )
                    .annotation {
                        if element.voters == 0 {
                            Text("0")
                                .foregroundColor(.textWhite40)
                                .font(.сaption2Regular)
                        }
                    }
                    .foregroundStyle(Color.chartBar)
                }
            }
            .frame(height: 200)
            .padding(.horizontal)
            .onAppear() {
                for (index, _) in mockChartData.first!.data.enumerated() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            votersChartData[index].animate = true
                        }
                    }
                    
                    
                }
            }
            
            Spacer()
        }
    }
}







struct ChampionVoters: Identifiable {
    let id = UUID()
    let date: Date
    let voters: Double
    var animate: Bool = false
}

private func formDate(year1: Int, month1: Int) -> Date {
    Calendar.current.date(from: .init(year: year1, month: month1)) ?? Date()
}


    var oldChampionVoters: [ChampionVoters] = [
        .init(date: formDate(year1: 2022, month1: 01), voters: 10),
        .init(date: formDate(year1: 2022, month1: 02), voters: 10),
        .init(date: formDate(year1: 2022, month1: 03), voters: 9.9),
        .init(date: formDate(year1: 2022, month1: 04), voters: 0),
        .init(date: formDate(year1: 2022, month1: 05), voters: 11.4),
        .init(date: formDate(year1: 2022, month1: 06), voters: 10.9),
        .init(date: formDate(year1: 2022, month1: 07), voters: 9.9),
        .init(date: formDate(year1: 2022, month1: 08), voters: 10.4),
        .init(date: formDate(year1: 2022, month1: 09), voters: 11.4),
        .init(date: formDate(year1: 2022, month1: 10), voters: 10.9),
        .init(date: formDate(year1: 2022, month1: 11), voters: 9.9),
        .init(date: formDate(year1: 2022, month1: 12), voters: 10.4)
    ]
    
    var newChampionVoters: [ChampionVoters] = [
        .init(date: formDate(year1: 2022, month1: 01), voters: 1),
        .init(date: formDate(year1: 2022, month1: 02), voters: 2),
        .init(date: formDate(year1: 2022, month1: 03), voters: 2.9),
        .init(date: formDate(year1: 2022, month1: 04), voters: 0),
        .init(date: formDate(year1: 2022, month1: 05), voters: 2.3),
        .init(date: formDate(year1: 2022, month1: 06), voters: 1.1),
        .init(date: formDate(year1: 2022, month1: 07), voters: 2.9),
        .init(date: formDate(year1: 2022, month1: 08), voters: 2.4),
        .init(date: formDate(year1: 2022, month1: 09), voters: 2.3),
        .init(date: formDate(year1: 2022, month1: 10), voters: 1.1),
        .init(date: formDate(year1: 2022, month1: 11), voters: 2.9),
        .init(date: formDate(year1: 2022, month1: 12), voters: 2.4)
    ]



struct DaoInfoInsightsDaoView_Previews: PreviewProvider {
    static var previews: some View {
        DaoInfoInsightsDaoView(dao: .aave)
    }
}
