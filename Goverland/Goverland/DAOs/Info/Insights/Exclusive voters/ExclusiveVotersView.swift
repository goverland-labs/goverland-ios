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

    private var data: String {
        if let percentage = dataSource.exclusiveVoters?.percent {
            return Utils.percentage(of: percentage, in: 100)
        }
        return ""
    }

    private var metadata: String {
        if let voters = dataSource.exclusiveVoters?.count {
            return "\(voters) voters"
        }
        return ""
    }

    var body: some View {
        if dataSource.exclusiveVoters?.count == 0 {
            EmptyView()
        } else {
            BrickView(header: "Exclusive voters",
                      data: data,
                      metadata: metadata,
                      isLoading: dataSource.isLoading,
                      failedToLoadInitialData: dataSource.failedToLoadInitialData,
                      onRefresh: dataSource.refresh)
            .onAppear() {
                if dataSource.exclusiveVoters == nil {
                    dataSource.refresh()
                }
            }
        }
    }
}
