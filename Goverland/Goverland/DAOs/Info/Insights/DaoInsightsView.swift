//
//  DaoInsightsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-28.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI


struct DaoInsightsView: View {
    let dao: Dao
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack {
                    SuccessfulProposalsView(dao: dao)
                    ExclusiveVotersView(dao: dao)
                }
                .padding(10)
                MonthlyActiveVotersGraphView(dao: dao)
                UserBucketsGraphView(dao: dao)
                MonthlyNewProposalsView(dao: dao)
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
