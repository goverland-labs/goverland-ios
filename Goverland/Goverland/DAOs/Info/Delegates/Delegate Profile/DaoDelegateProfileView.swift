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
                    DaoDelegateProfileHeaderView(delegate: dataSource.delegate, dao: dataSource.dao)
                        .padding(.horizontal)
                        .padding(.bottom)

                    FilterButtonsView<DaoDelegateProfileFilter>(filter: $filter) { _ in }

                    switch filter {
                    case .activity: DaoDelegateProfileActivityView(proposals: [.aaveTest])
                    case .about: DaoDelegateProfileAbout(delegate: dataSource.delegate)
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
                Text(dataSource.dao.name)
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
    let delegate: Delegate
    let dao: Dao
    
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    
    var body: some View {
        VStack(spacing: 10) {
            RoundPictureView(image: delegate.user.avatar(size: .xl), imageSize: Avatar.Size.xl.profileImageSize)
            
            Text(delegate.user.usernameShort)
                .font(.title3Semibold)
                .foregroundColor(.textWhite)
            HStack {
                Text(delegate.user.address.short)
                if let resolvedName =  delegate.user.resolvedName {
                    Text("|")
                    Text(resolvedName)
                }
            }
            .foregroundColor(.textWhite60)
            .font(.footnoteRegular)
            
            HStack(spacing: 10) {
                HStack(spacing: 2) {
                    Image(systemName: "person.fill")
                    Text(String(delegate.delegators))
                }
                HStack(spacing: 2) {
                    Image(systemName: "person.fill")
                    Text(String(delegate.votes))
                }
                HStack(spacing: 2) {
                    Image(systemName: "doc.text")
                    Text(String(delegate.proposalsCreated))
                }
            }
            .foregroundColor(.textWhite40)
            .font(.footnoteRegular)
            
            DelegateButton(isDelegated: delegate.delegationInfo != nil) {
                activeSheetManager.activeSheet = .daoDelegateAction(dao, delegate)
            }
        }
    }
}
