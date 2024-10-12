//
//  MyDelegatesListView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-10-08.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import SwiftData

struct MyDelegatesListView: View {
    @ObservedObject var dataSource: MyDelegatesDataSource
    
    var body: some View {
        List {
            ForEach(dataSource.userDelegates) { userDaoDelegates in
                Section(header: headerview(dao: userDaoDelegates.dao)) {
                    let delegates: [UserDelegate] = userDaoDelegates.delegates
                    ForEach(delegates) { userDelegate in
                        HStack {
                            HStack {
                                UserPictureView(user: userDelegate.delegate, size: .xs)
                                Text("\(userDelegate.delegate.usernameShort)")
                            }
                            Spacer()
                            HStack {
                                if userDelegate.delegate.address == dataSource.appUserId {
                                    Text("Self delegation")
                                        .font(.caption2)
                                        .foregroundColor(.textWhite)
                                        .frame(width: 100)
                                        .padding(.vertical, 5)
                                        .background(Capsule()
                                            .fill(Color.tertiaryContainer))
                                }
                                // swiftUI bug if run this code
//                                Text("\(Utils.numberWithPercent(from: userDelegate.percentDelegated))")
//                                    .font(.footnote)
//                                    .foregroundColor(.textWhite60)
//                                    .frame(width: 35)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("My delegates")
        .onAppear() {
            //Tracker.track(.screen)
            if dataSource.userDelegates.isEmpty {
                dataSource.refresh()
            }
        }
    }
}

fileprivate struct headerview: View {
    let dao: Dao
    var body: some View {
        HStack {
            HStack {
                RoundPictureView(image: dao.avatar(size: .xs), imageSize: Avatar.Size.xs.daoImageSize)
                Text(dao.name)
                    .font(.footnoteSemibold)
                    .foregroundColor(.textWhite)
                    .textCase(.none)
            }
            Spacer()
            Text("Edit")
                .font(.subheadlineSemibold)
                .foregroundColor(.primaryDim)
                .textCase(.none)
        }
        .padding(.bottom, 5)
    }
    
}
