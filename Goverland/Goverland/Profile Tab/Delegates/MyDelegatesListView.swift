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
    @StateObject var dataSource = MyDelegatesDataSource.shared
    @Query private var profiles: [UserProfile]
    
    private var appUser: User {
        let profile = profiles.first(where: { $0.selected })!
        return profile.user
    }
    
    var body: some View {
        List {
            ForEach(dataSource.delegations) { delegation in
                Section(header: headerview(dao: delegation.dao)) {
                    ForEach(delegation.delegations) { d in
                        HStack {
                            HStack {
                                UserPictureView(user: d.delegate, size: .xs)
                                Text("\(d.delegate.usernameShort)")
                            }
                            Spacer()
                            HStack {
                                if d.delegate == appUser {
                                    Text("Self delegation")
                                        .font(.caption2)
                                        .foregroundColor(.textWhite)
                                        .frame(width: 100)
                                        .padding(.vertical, 5)
                                        .background(Capsule()
                                            .fill(Color.tertiaryContainer))
                                }
                                Text("\(Utils.numberWithPercent(from: d.percent_of_delegated))")
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
        .navigationTitle("My delegates")
        .onAppear() {
            //Tracker.track(.screen)
            if dataSource.delegations.isEmpty {
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
