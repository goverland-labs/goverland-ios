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
            Text("Hello, World!")
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("My delegates")
        .onAppear() {
            //Tracker.track(.screen)
            if dataSource.delegates.isEmpty {
                dataSource.refresh()
            }
        }
    }
}
