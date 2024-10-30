//
//  MyDelegatesView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-10-08.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

struct MyDelegatesView: View {
    let count: Int
    let appUser: User
    @StateObject var dataSource: MyDelegatesDataSource
    
    init(count: Int, appUser: User) {
        self.count = count
        self.appUser = appUser
        self._dataSource = StateObject(wrappedValue: MyDelegatesDataSource())
    }
    
    var body: some View {
        VStack {
            NavigationLink(destination: MyDelegatesListView(appUser: appUser, dataSource: dataSource)) {
                HStack {
                    HStack {
                        Image(systemName: "person.wave.2.fill")
                        Text("My delegates")
                    }
                    .font(.subheadlineSemibold)
                    .foregroundColor(.textWhite)
                    Spacer()
                    HStack {
                        Text("\(count)")
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
