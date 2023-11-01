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
            if proposals.finished != 0 {
                let percentage = Double(proposals.succeeded) / Double(proposals.finished)
                return "\(Utils.formattedNumber(percentage))%"
            }
        }
        return "NaN"
    }
    
    private var metadata: String {
        if let totalProposals = dataSource.successfulProposals?.succeeded {
            return "\(totalProposals) proposals"
        }
        return "NaN"
    }
    
    var body: some View {
        BrickView(header: "Successful proposals",
                  data: data,
                  metadata: metadata,
                  isLoading: dataSource.isLoading,
                  failedToLoadInitialData: dataSource.failedToLoadInitialData,
                  onRefresh: dataSource.refresh)
        .onAppear() {
            if dataSource.successfulProposals == nil {
                //dataSource.refresh()
            }
        }
    }
}

