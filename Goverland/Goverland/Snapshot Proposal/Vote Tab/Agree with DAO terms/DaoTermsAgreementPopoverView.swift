//
//  DaoTermsAgreementPopoverView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 01.02.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import SwiftData

struct DaoTermsAgreementPopoverView: View {
    let dao: Dao
    let onAgree: () -> Void
    @Environment(\.dismiss) private var dismiss
    @Query private var termsAgreements: [DaoTermsAgreement]

    var body: some View {
        VStack {
            Text("Terms of Service")
                .font(.title3Semibold)
                .foregroundColor(.textWhite)
                .padding(.top, 8)

            Spacer()

            HStack(alignment: .top, spacing: 8) {
                BulletedListsDot()                
                Text("You must agree to the \(dao.name) ") +
                Text("Terms of Service").foregroundStyle(Color.primaryDim).underline() +
                Text(" to vote on this proposal.")
            }
            .onTapGesture {
                openUrl(dao.terms!)
            }

            Spacer()

            HStack(spacing: 16) {
                SecondaryButton("Cancel") {
                    dismiss()
                }

                PrimaryButton("I agree") {
                    Haptic.medium()
                    Tracker.track(.snpDaoTermsAgree)
                    Task {
                        try! DaoTermsAgreement.upsert(dao: dao)
                        onAgree()
                    }
                    dismiss()
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .onAppear {
            Tracker.track(.screenSnpDaoTerms)
        }
    }
}
