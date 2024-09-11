//
//  DelegationSuccessView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 06.09.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DelegationSuccessView: View {
    let txScanTemplate: String
    @StateObject private var model: DelegationSuccessModel

    @Environment(\.dismiss) private var dismiss

    init(chainId: Int, txHash: String, txScanTemplate: String) {
        self.txScanTemplate = txScanTemplate
        _model = StateObject(wrappedValue: DelegationSuccessModel(chainId: chainId, txHash: txHash))
    }

    var txUrl: URL? {
        URL(string: txScanTemplate.replacingOccurrences(of: ":id", with: model.txHash))
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Delegating")

            Spacer()

            switch model.txStatus {
            case .pending:
                Text("Pending")
            case .success:
                Text("Success")
            case .failed:
                Text("Failed")
            }

            Spacer()

            VStack {
                Text("Delegation proportions can be changed at any time")
                Text("View Tx")
                    .underline()
                    .onTapGesture {
                        if let txUrl {
                            openUrl(txUrl)
                        }
                    }
            }
            .foregroundStyle(Color.textWhite60)
            .font(.footnoteRegular)

            PrimaryButton("Close") {
                dismiss()
            }
        }
        .onAppear {
            // TODO: track
            model.monitor()
        }
    }
}
