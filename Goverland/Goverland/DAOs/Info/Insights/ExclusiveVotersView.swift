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
        BrickView(header: "Exclusive voters",
                  subheader: "Exclusive",
                  data: dataSource.exclusiveVoters.isEmpty ? " " : "\(dataSource.exclusiveVoters.first!.percent)%",
                  metaData: dataSource.exclusiveVoters.isEmpty ? " " : "\(dataSource.exclusiveVoters.first!.count) voters",
                  width: .infinity,
                  height: 100,
                  isLoading: dataSource.isLoading,
                  failedToLoadInitialData: dataSource.failedToLoadInitialData,
                  onRefresh: dataSource.refresh)
        .onAppear() {
            if dataSource.exclusiveVoters.isEmpty {
                dataSource.refresh()
            }
        }
        
        
    }
}

#Preview {
    ExclusiveVotersView(dao: .aave)
}
