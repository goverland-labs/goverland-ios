//
//  MyDelegators.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-10-11.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct MyDelegatorsView: View {
    @ObservedObject var dataSource: MyDelegatorsDataSource
    
    var body: some View {
        VStack {
            NavigationLink(destination: MyDelegatorsListView(dataSource: dataSource)) {
                HStack {
                    HStack {
                        Image(systemName: "heart.fill")
                        Text("My delegators")
                    }
                    .font(.subheadlineSemibold)
                    .foregroundColor(.textWhite)
                    Spacer()
                    HStack {
                        Text("\(dataSource.delegatorsCount)")
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
