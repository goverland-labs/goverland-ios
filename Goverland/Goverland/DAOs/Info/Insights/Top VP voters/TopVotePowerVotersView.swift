//
//  TopVotePowerVotersView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-07.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct TopVotePowerVotersView: View {
    @StateObject private var dataSource: TopVotePowerVotersDataSource

    init(dao: Dao) {
        let dataSource = TopVotePowerVotersDataSource(dao: dao)
        _dataSource = StateObject(wrappedValue: dataSource)
    }
    
    var body: some View {
        Text("Hello, World!")
            .onAppear {
                if dataSource.topVotePowerVoters?.isEmpty ?? true {
                    dataSource.refresh()
                }
            }
    }
}
