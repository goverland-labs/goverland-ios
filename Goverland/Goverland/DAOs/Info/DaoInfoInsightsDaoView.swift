//
//  DaoInfoInsightsDaoView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-28.
//

import SwiftUI

struct DaoInfoInsightsDaoView: View {
    let dao: Dao
    
    var body: some View {
        VStack {
            Text("Beautiful graphs are coming up!")
            Spacer()
        }
    }
}

struct DaoInfoInsightsDaoView_Previews: PreviewProvider {
    static var previews: some View {
        DaoInfoInsightsDaoView(dao: .aave)
    }
}
