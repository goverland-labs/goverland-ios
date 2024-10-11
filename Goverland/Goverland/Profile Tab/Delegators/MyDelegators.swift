//
//  MyDelegators.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-10-11.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct MyDelegators: View {
    @StateObject private var dataSource = MyDelegatorsDataSource.shared
    
    var body: some View {
        VStack {
            NavigationLink(destination: MyDelegatorsListView()) {
                HStack {
                    HStack {
                        Image(systemName: "heart.fill")
                        Text("My delegators")
                    }
                    .font(.subheadlineSemibold)
                    .foregroundColor(.textWhite)
                    Spacer()
                    HStack {
                        Text("\(dataSource.delegations.count)")
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
