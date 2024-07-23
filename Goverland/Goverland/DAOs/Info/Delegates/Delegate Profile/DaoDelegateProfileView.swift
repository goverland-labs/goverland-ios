//
//  DaoDelegateProfileView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 11.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DaoDelegateProfileView: View {
    @StateObject private var dataSource: DaoDelegateProfileDataSource
    
    init(dao: Dao, delegate: Delegate) {
        _dataSource = StateObject(wrappedValue: DaoDelegateProfileDataSource(dao: dao, delegate: delegate))
    }
    
    var body: some View {
        VStack {
            Text("Delegate info view")
            Text("\(dataSource.delegateProfile?.id.description)")
        }
        .onAppear() {
            dataSource.refresh()
        }
    }
}
