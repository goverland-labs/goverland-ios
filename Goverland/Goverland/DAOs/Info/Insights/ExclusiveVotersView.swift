//
//  ExclusiveVotersView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-20.
//

import SwiftUI

struct ExclusiveVotersView: View {
    @StateObject private var dataSource: ExclusiveVotersDataSource
    
    init(dao: Dao) {
        let dataSource = ExclusiveVotersDataSource(dao: dao)
        _dataSource = StateObject(wrappedValue: dataSource)
    }
    
    
    var body: some View {
        BrickView(title: "Exclusive voters",
                  subTitle: "",
                  data: "94%",
                  metaData: "123.4K voters")
    }
}

#Preview {
    ExclusiveVotersView(dao: .aave)
}
