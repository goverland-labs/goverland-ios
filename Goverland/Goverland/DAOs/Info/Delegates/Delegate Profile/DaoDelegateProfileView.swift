//
//  DaoDelegateProfileView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 11.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

enum DaoDelegateProfileFilter: Int, FilterOptions {
    case activity = 0
    case about
    case insights

    var localizedName: String {
        switch self {
        case .activity:
            return "Activity"
        case .about:
            return "About"
        case .insights:
            return "Insights"
        }
    }
}

struct DaoDelegateProfileView: View {
    let dao: Dao
    let delegate: Delegate
    
    @Environment(\.dismiss) private var dismiss
    @State private var filter: DaoDelegateProfileFilter = .activity
    
    var body: some View {
        VStack {
            
            VStack(spacing: 0) {
                DaoDelegateProfileHeaderView(delegate: delegate, dao: dao)
                    .padding(.horizontal)
                    .padding(.bottom)
                
                FilterButtonsView<DaoDelegateProfileFilter>(filter: $filter) { _ in }
                
                switch filter {
                case .activity: DaoDelegateProfileActivityView(proposals: [.aaveTest])
                case .about: DaoDelegateProfileAboutView(delegate: delegate)
                case .insights: EmptyView()
                }
            }
            Spacer()
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
                    Image("cast-your-vote-grey")
                    Text(String(delegate.votes))
                }
                HStack(spacing: 2) {
                    Image(systemName: "doc.text")
                    Text(String(delegate.proposalsCreated))
                }
            }
            .foregroundColor(.textWhite40)
            .font(.footnoteRegular)
            
            DelegateButton(isDelegated: delegate.delegationInfo.percentDelegated != 0) {
                activeSheetManager.activeSheet = .daoUserDelegate(dao, delegate.user)
            }
        }
    }
}
