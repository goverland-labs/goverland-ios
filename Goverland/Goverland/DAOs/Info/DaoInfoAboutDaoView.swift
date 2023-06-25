//
//  DaoInfoAboutDaoView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-25.
//

import SwiftUI

struct DaoInfoAboutDaoView: View {
    let dao: Dao
    
    var body: some View {
        VStack {
            Text("Dao Info About Dao View")
            Text("dao name is \(dao.name)")
        }
    }
}

struct DaoInfoAboutDaoView_Previews: PreviewProvider {
    static var previews: some View {
        DaoInfoAboutDaoView(dao: .aave)
    }
}
