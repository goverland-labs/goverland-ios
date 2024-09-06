//
//  DelegationSuccessView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 06.09.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DelegationSuccessView: View {
    let txId: String
    let txScanTemplate: String

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        let url = URL(string: txScanTemplate.replacingOccurrences(of: ":id", with: txId))!
        VStack {
            Text("Delegating")

            Spacer()

            Text(url.absoluteString)
                .onTapGesture {
                    openUrl(url)
                }

            Spacer()

            PrimaryButton("Close") {
                dismiss()
            }
        }
    }
}
