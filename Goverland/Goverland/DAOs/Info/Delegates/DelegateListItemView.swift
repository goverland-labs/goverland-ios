//
//  DelegateCardView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 11.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DelegateListItemView: View {
    let dao: Dao
    let delegate: Delegate

    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    @Environment(\.isPresented) private var isPresented

    private var backgroundColor: Color {
        isPresented ? .containerBright : .container
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            _DelegateListItemHeaderView(dao: dao, delegate: delegate)
            _DelegateListItemBodyView(delegate: delegate)
            _DelegateListItemFooterView(delegate: delegate)
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.vertical, Constants.horizontalPadding)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor))
        .onTapGesture {
            activeSheetManager.activeSheet = .daoDelegateProfileById(daoId: dao.id.uuidString, delegateId: delegate.id, delegateAction: .delegate)
        }
    }
}

fileprivate struct _DelegateListItemHeaderView: View {
    let dao: Dao
    let delegate: Delegate

    var body: some View {
        HStack(spacing: Constants.horizontalPadding) {
            RoundPictureView(image: delegate.user.avatar(size: .m), imageSize: Avatar.Size.m.profileImageSize)

            VStack(alignment: .leading, spacing: 6) {
                Text(delegate.user.usernameShort)
                    .foregroundStyle(Color.textWhite)
                    .font(.bodySemibold)
                    .lineLimit(1)

                Text("\(Utils.formattedNumber(delegate.votingPower.power)) \(delegate.votingPower.symbol)")
                    .foregroundStyle(Color.textWhite60)
                    .font(.footnoteRegular)
                    .lineLimit(1)

//  TODO: clarify design
//                if delegate.user.resolvedName != nil {
//                    Text(delegate.user.address.short)
//                        .foregroundStyle(Color.textWhite60)
//                        .font(.footnoteRegular)
//                        .lineLimit(1)
//                }
            }

            Spacer()

            DelegateButton(dao: dao, delegate: delegate) {
                Tracker.track(.dlgActionFromDelegatesList)
            }
        }
    }
}

fileprivate struct _ShimmerDelegateListItemHeaderView: View {
    var body: some View {
        HStack(spacing: Constants.horizontalPadding) {
            ShimmerView()
                .frame(width: Avatar.Size.m.profileImageSize, height: Avatar.Size.m.profileImageSize)
                .cornerRadius(Avatar.Size.m.profileImageSize)

            VStack(alignment: .leading, spacing: 6) {
                ShimmerView.rounded(width: 130, height: 18)
                ShimmerView.rounded(width: 90, height: 14)
            }

            Spacer()

            ShimmerView.rounded(width: 100, height: 32)
        }
    }
}

fileprivate struct _DelegateListItemBodyView: View {
    let delegate: Delegate

    var body: some View {
        VStack {
            Text(delegate.statement)
                .font(.footnoteRegular)
                .foregroundStyle(Color.textWhite)
                .lineLimit(3)
                .multilineTextAlignment(.leading)

            Spacer()
        }
    }
}

fileprivate struct _ShimmerDelegateListItemBodyView: View {
    var body: some View {
        VStack {
            ForEach(0..<3) { _ in
                ShimmerView()
                    .frame(height: 12)
                    .cornerRadius(6)
            }
        }
    }
}

fileprivate struct _DelegateListItemFooterView: View {
    let delegate: Delegate

    var body: some View {
        HStack(spacing: 10) {
            HStack(spacing: 5) {
                Image(systemName: "person.fill")
                Text(Utils.formattedNumber(Double(delegate.delegators)))
            }

            HStack(spacing: 5) {
                Image("ballot")
                    .frame(width: 12)
                Text(Utils.formattedNumber(Double(delegate.votes)))
            }

            HStack(spacing: 5) {
                Image(systemName: "doc.text.fill")
                Text(Utils.formattedNumber(Double(delegate.proposalsCreated)))
            }

            Spacer()
        }
        .font(.footnoteRegular)
        .foregroundStyle(Color.textWhite40)
    }
}

fileprivate struct _ShimmerDelegateListItemFooterView: View {
    var body: some View {
        HStack {
            ShimmerView.rounded(width: 120, height: 20)
            Spacer()
        }
    }
}

struct ShimmerDelegateListItemView: View {
    var body: some View {
        VStack(spacing: 16) {
            _ShimmerDelegateListItemHeaderView()
            _ShimmerDelegateListItemBodyView()
            _ShimmerDelegateListItemFooterView()
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.vertical, Constants.horizontalPadding)
        .frame(height: 174)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.container))
    }
}
