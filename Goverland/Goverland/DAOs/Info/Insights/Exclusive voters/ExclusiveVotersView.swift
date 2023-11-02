//
//  ExclusiveVotersView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-20.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct ExclusiveVotersView: View {
    @StateObject private var dataSource: ExclusiveVotersDataSource

    init(dao: Dao) {
        let dataSource = ExclusiveVotersDataSource(dao: dao)
        _dataSource = StateObject(wrappedValue: dataSource)
    }

    private var data: String {
        if let voters = dataSource.voters {
            return Utils.percentage(of: voters.exclusive, in: voters.total)
        }
        return ""
    }

    private var metadata: String {
        if let voters = dataSource.voters?.exclusive {
            return "\(voters) voters"
        }
        return ""
    }

    var body: some View {
        BrickView(header: "Exclusive voters",
                  data: data,
                  metadata: metadata,
                  isLoading: dataSource.isLoading,
                  failedToLoadInitialData: dataSource.failedToLoadInitialData,
                  onRefresh: dataSource.refresh)
        .onAppear() {
            if dataSource.voters == nil {
                dataSource.refresh()
            }
        }
    }
}
