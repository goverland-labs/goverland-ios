//
//  MyDelegatesView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-10-08.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct MyDelegatesView: View {
    @ObservedObject var dataSource: MyDelegatesDataSource
    
    var body: some View {
        VStack {
            NavigationLink(destination: MyDelegatesListView(dataSource: dataSource)) {
                HStack {
                    HStack {
                        Image(systemName: "person.wave.2.fill")
                        Text("My delegates")
                    }
                    .font(.subheadlineSemibold)
                    .foregroundColor(.textWhite)
                    Spacer()
                    HStack {
                        Text("\(dataSource.delegatesCount)")
                        Image(systemName: "chevron.right")
                    }
                    .font(.subheadlineSemibold)
                    .foregroundColor(.textWhite40)
                }
                .padding()
                .background(Color.container)
                .cornerRadius(20)
                .padding(.horizontal, Constants.horizontalPadding)
            }
        }
    }
}
