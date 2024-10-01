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
    @StateObject private var dataSource: DaoDelegateProfileDataSource

    let action: DelegateAction

    @Environment(\.dismiss) private var dismiss
    @State private var filter: DaoDelegateProfileFilter = .activity

    init(daoId: String, delegateId: String, action: DelegateAction) {
        self.action = action
        _dataSource = StateObject(wrappedValue: DaoDelegateProfileDataSource(daoId: daoId, delegateId: delegateId))
    }

    var daoDelegate: DaoDelegate? { dataSource.daoDelegate }

    private var isDelegated: Bool {
        guard let delegationInfo = dataSource.daoDelegate?.delegate.delegationInfo else { return false }
        return delegationInfo.percentDelegated != 0
    }

    var body: some View {
        VStack {
            if dataSource.isLoading {
                ProgressView()
                    .foregroundStyle(Color.textWhite20)
                    .controlSize(.regular)
                Spacer()
            } else if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the delegate information")
            } else if let daoDelegate {
                VStack(spacing: 0) {
                    DaoDelegateProfileHeaderView(delegate: daoDelegate.delegate, dao: daoDelegate.dao, action: action)
                        .padding(.horizontal)
                        .padding(.bottom)

                    FilterButtonsView<DaoDelegateProfileFilter>(filter: $filter)

                    switch filter {
                    case .activity: DaoDelegateProfileActivityView(dao: daoDelegate.dao,
                                                                   delegateId: daoDelegate.delegate.user.address.value,
                                                                   delegated: isDelegated)
                    case .about: DaoDelegateProfileAboutView(delegate: daoDelegate.delegate)
                    case .insights: DaoDelegateInsightsView(delegate: daoDelegate.delegate)
                    }
                }
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
                Text(daoDelegate?.dao.name ?? "DAO")
                    .font(.title3Semibold)
                    .foregroundStyle(Color.textWhite)

                if daoDelegate?.dao.verified ?? false {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(Color.textWhite)
                }
            }

            if let daoDelegate {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        DaoDelegateSharingMenu(daoDelegate: daoDelegate)
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(Color.textWhite)
                            .fontWeight(.bold)
                            .frame(height: 20)
                    }
                }
            }
        }
        .onAppear {
            if dataSource.daoDelegate == nil {
                dataSource.refresh()
            }
            Tracker.track(.screenDelegateProfile)
        }
    }
}

struct DaoDelegateProfileHeaderView: View {
    let delegate: Delegate
    let dao: Dao
    let action: DelegateAction

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    var body: some View {
        HStack(spacing: 30) {
            RoundPictureView(image: delegate.user.avatar(size: .xl), imageSize: Avatar.Size.xl.profileImageSize)
                .onTapGesture {
                    activeSheetManager.activeSheet = .publicProfileById(delegate.user.address.value)
                }

            VStack(spacing: 10) {
                VStack(spacing: 4) {
                    Text(delegate.user.usernameShort)
                        .font(.title3Semibold)
                        .foregroundColor(.textWhite)
                        .onTapGesture {
                            if let resolvedName = delegate.user.resolvedName {
                                UIPasteboard.general.string = resolvedName
                                showToast("Name copied")
                            } else {
                                UIPasteboard.general.string = delegate.user.address.value
                                showToast("Address copied")
                            }
                        }

                    if delegate.user.resolvedName != nil {
                        Text(delegate.user.address.short)
                            .foregroundColor(.textWhite60)
                            .font(.footnoteRegular)
                            .onTapGesture {
                                UIPasteboard.general.string = delegate.user.address.value
                                showToast("Address copied")
                            }
                    }
                }

                DelegateIconsView(delegate: delegate)
                    .padding(.bottom, 4)

                switch action {
                case .delegate:
                    DelegateButton(dao: dao, delegate: delegate) {
                        Tracker.track(.dlgActionFromDelegateProfile)
                    }
                case .add(let onAdd):
                    SecondaryButton("Add", maxWidth: 100, height: 32, font: .footnoteSemibold) {
                        dismiss()
                        onAdd(delegate)
                    }
                }
            }
        }
    }
}
