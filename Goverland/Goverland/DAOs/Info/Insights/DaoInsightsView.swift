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

    @State private var topDaoDatesFilteringOption: DatesFiltetingOption = .oneYear

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
                TopDaoVotersView(dao: dao, filteringOption: $topDaoDatesFilteringOption)
                TopDaoVotersDistributionView(dao: dao, datesFilteringOption: $topDaoDatesFilteringOption)
                MonthlyNewProposalsView(dao: dao)
                MutualDaosView(dao: dao)
                    .padding(.bottom, 16)
            }
            .onAppear() {
                Tracker.track(.screenDaoInsights)
            }
        }
        .scrollIndicators(.hidden)
    }
}
