//
//  MyDelegatesListView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-10-08.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct MyDelegatesListView: View {
    @StateObject var dataSource = MyDelegatesDataSource.shared
    
    var body: some View {
        VStack {
            List(dataSource.delegations) { delegation in
                Section("\(delegation)") {
                    ForEach(delegation.delegations) { d in
                        HStack {
                            Text("\(d.delegate.usernameShort)")
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("My delegates")
        .onAppear() {
            //Tracker.track(.screen)
            if dataSource.delegations.isEmpty {
                dataSource.refresh()
            }
        }
    }
}
