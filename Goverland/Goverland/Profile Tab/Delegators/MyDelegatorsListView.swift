//
//  MyDelegatorsListView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-10-11.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct MyDelegatorsListView: View {
    @ObservedObject var dataSource: MyDelegatorsDataSource
    
    var body: some View {
        List {
            ForEach(dataSource.userDelegators) { userDaoDelegator in
                Section(header: headerview(dao: userDaoDelegator.dao)) {
                    let delegators: [UserDelegator] = userDaoDelegator.delegators
                    ForEach(delegators) { userDelegator in
                        HStack {
                            HStack {
                                UserPictureView(user: userDelegator.delegator, size: .xs)
                                Text("\(userDelegator.delegator.usernameShort)")
                            }
                            Spacer()
                            HStack {
                                if userDelegator.delegator.address == dataSource.appUserId {
                                    Text("Self delegation")
                                        .font(.caption2)
                                        .foregroundColor(.textWhite)
                                        .frame(width: 100)
                                        .padding(.vertical, 5)
                                        .background(Capsule()
                                            .fill(Color.tertiaryContainer))
                                }
                                Text("\(Utils.formattedNumber(userDelegator.votingPower))")
                                    .font(.footnote)
                                    .foregroundColor(.textWhite60)
                                    .frame(width: 35)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("My delegators")
        .onAppear() {
            //Tracker.track(.screen)
            if dataSource.userDelegators.isEmpty {
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
        }
        .padding(.bottom, 5)
    }
}

