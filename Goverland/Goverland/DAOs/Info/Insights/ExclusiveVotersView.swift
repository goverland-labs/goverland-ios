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
            return "\(Utils.formattedNumber(percentage))%"
        }
        return "NaN"
    }

    private var metadata: String {
        if let voters = dataSource.exclusiveVoters?.count {
            return "\(voters) voters"
        }
        return "NaN"
    }

    var body: some View {
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

#Preview {
    ExclusiveVotersView(dao: .aave)
}
