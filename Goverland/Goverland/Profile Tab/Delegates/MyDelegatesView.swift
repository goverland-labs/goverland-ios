//
//  MyDelegatesView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-10-08.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct MyDelegatesView: View {
    @StateObject private var dataSource = MyDelegatesDataSource.shared
    
    var body: some View {
        VStack {
            HStack {
                Text("Delegations")
                    .font(.subheadlineSemibold)
                    .foregroundStyle(Color.textWhite)
                Spacer()
            }
            .padding(.top, 16)
            .padding(.horizontal, Constants.horizontalPadding * 2)

            
            NavigationLink(destination: MyDelegatesListView()) {
                HStack {
                    HStack {
                        Image(systemName: "person.wave.2.fill")
                        Text("My delegates")
                    }
                    .font(.subheadlineSemibold)
                    .foregroundColor(.textWhite)
                    Spacer()
                    HStack {
                        Text("4")
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
