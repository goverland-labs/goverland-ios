//
//  DaoInsightsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-28.
//

import SwiftUI


struct DaoInsightsView: View {
    let dao: Dao
    
    var body: some View {
        ScrollView {
            VStack {
                MonthlyActiveVotersGraphView(dao: dao)
                UserBucketsGraphView(dao: dao)
            }
            .onAppear() {
                Tracker.track(.screenDaoInsights)
            }
        }
        .scrollIndicators(.hidden)
    }
}

struct DaoInfoInsightsDaoView_Previews: PreviewProvider {
    static var previews: some View {
        DaoInsightsView(dao: .aave)
    }
}
