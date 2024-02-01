//
//  DaoTermsAgreementView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 01.02.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import SwiftData

struct DaoTermsAgreementView: View {
    let dao: Dao
    @Environment(\.dismiss) private var dismiss
    @Query private var termsAgreements: [DaoTermsAgreement]

    var body: some View {
        VStack {
            Text("Terms of Service")
                .font(.title3Semibold)
                .foregroundColor(.textWhite)
                .padding(.top, 20)

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
                    Task {
                        try! DaoTermsAgreement.upsert(dao: dao)
                    }
                    dismiss()
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
