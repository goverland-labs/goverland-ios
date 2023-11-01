//
//  SuccessfulProposalsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-30.
//

import SwiftUI

struct SuccessfulProposalsView: View {
    @StateObject private var dataSource: SuccessfulProposalsDataSource
    
    init(dao: Dao) {
        let dataSource = SuccessfulProposalsDataSource(dao: dao)
        _dataSource = StateObject(wrappedValue: dataSource)
    }
    
    private var data: String {
        if let proposals = dataSource.successfulProposals {
            return Utils.percentage(of: proposals.succeeded, in: proposals.finished)
        }
        return ""
    }
    
    private var metadata: String {
        if let succeededProposals = dataSource.successfulProposals?.succeeded {
            return "\(succeededProposals) proposals"
        }
        return ""
    }
    
    var body: some View {
        if dataSource.successfulProposals?.finished == 0 {
            EmptyView()
        } else {
            BrickView(header: "Successful proposals",
                      data: data,
                      metadata: metadata,
                      isLoading: dataSource.isLoading,
                      failedToLoadInitialData: dataSource.failedToLoadInitialData,
                      onRefresh: dataSource.refresh)
            .onAppear() {
                if dataSource.successfulProposals == nil {
                    dataSource.refresh()
                }
            }
        }
    }
}

