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
        MonthlyActiveVotersGraphView(dao: dao)
    }
}

struct DaoInfoInsightsDaoView_Previews: PreviewProvider {
    static var previews: some View {
        DaoInsightsView(dao: .aave)
    }
}
