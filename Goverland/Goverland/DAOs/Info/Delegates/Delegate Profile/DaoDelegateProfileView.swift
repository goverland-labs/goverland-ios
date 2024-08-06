//
//  DaoDelegateProfileView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 11.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DaoDelegateProfileView: View {
    @StateObject private var dataSource: DaoDelegateProfileDataSource
    @Environment(\.dismiss) private var dismiss
    @State private var filter: DaoDelegateProfileFilter = .activity
    
    var dao: Dao { dataSource.dao }
    var delegate: Delegate { dataSource.delegate }
    
    init(dao: Dao, delegate: Delegate) {
        _dataSource = StateObject(wrappedValue: DaoDelegateProfileDataSource(dao: dao, delegate: delegate))
    }
    
    var body: some View {
        VStack {
            if dataSource.isLoading {
                // Unfortunately shimmer or reducted view here breaks presentation in a popover view
                ProgressView()
                    .foregroundStyle(Color.textWhite20)
                    .controlSize(.regular)
                Spacer()
            } else if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the delegate information")
            } else if let delegateProfile = dataSource.delegateProfile {
                VStack(spacing: 0) {
                    DaoDelegateProfileHeaderView(delegateProfile: delegateProfile)
                        .padding(.horizontal)
                        .padding(.bottom)

                    FilterButtonsView<DaoDelegateProfileFilter>(filter: $filter) { _ in }

                    switch filter {
                    case .activity: DaoDelegateProfileActivityView(proposals: delegateProfile.proposals)
                    case .about: EmptyView()
                    case .insights: EmptyView()
                    }
                }
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }

            ToolbarItem(placement: .principal) {
                Text(dao.name)
                    .font(.title3Semibold)
                    .foregroundStyle(Color.textWhite)
            }
        }
        .onAppear() {
            if dataSource.delegateProfile == nil {
                dataSource.refresh()
            }
        }
    }
}



struct DaoDelegateProfileHeaderView: View {
    let delegateProfile: DelegateProfile
    
    var body: some View {
        VStack(spacing: 10) {
            RoundPictureView(image: delegateProfile.delegate.user.avatar(size: .xl), imageSize: Avatar.Size.xl.profileImageSize)
            
            Text(delegateProfile.delegate.user.usernameShort)
                .font(.title3Semibold)
                .foregroundColor(.textWhite)
            HStack {
                Text(delegateProfile.delegate.user.address.short)
                if let resolvedName =  delegateProfile.delegate.user.resolvedName {
                    Text("|")
                    Text(resolvedName)
                }
            }
            .foregroundColor(.textWhite60)
            .font(.footnoteRegular)
            
            HStack(spacing: 10) {
                HStack(spacing: 2) {
                    Image(systemName: "person.fill")
                    Text("543")
                }
                HStack(spacing: 2) {
                    Image(systemName: "person.fill")
                    Text("543")
                }
                HStack(spacing: 2) {
                    Image(systemName: "doc.text")
                    Text("0")
                }
            }
            .foregroundColor(.textWhite40)
            .font(.footnoteRegular)
            
//            DelegateButtonView(delegationID: nil, onDelegateToggle: { didDelegate in
//                if didDelegate {
//                    //TODO: Traker here
//                }
//            })
        }
    }
}
