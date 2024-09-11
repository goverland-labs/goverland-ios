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

    @StateObject private var orientationManager = DeviceOrientationManager.shared
    @Environment(\.dismiss) private var dismiss

    init(chainId: Int, txHash: String, txScanTemplate: String) {
        self.txScanTemplate = txScanTemplate
        _model = StateObject(wrappedValue: DelegationSuccessModel(chainId: chainId, txHash: txHash))
    }

    private var header: String {
        switch model.txStatus {
        case .pending:
            "Pending..."
        case .success:
            "Delegated!"
        case .failed:
            "Hmm, transaction is failed..."
        }
    }

    private var txUrl: URL? {
        URL(string: txScanTemplate.replacingOccurrences(of: ":id", with: model.txHash))
    }

    private var txUrlHost: String {
        guard let txUrl else { return "scanner" }
        return txUrl.host() ?? "scanner"
    }

    private var scaleRatio: Double {
        if orientationManager.currentOrientation.isLandscape {
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                return 1/6
            default:
                return 1/3
            }
        } else {
            return 3/5
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Text(header)
                        .font(.title3Semibold)
                        .foregroundStyle(Color.textWhite)

                    Spacer()

                    switch model.txStatus {
                    case .pending:
                        LottieView(animationName: "pending")
                            .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                    case .success:
                        LottieView(animationName: "vote-success")
                            .frame(width: geometry.size.width * scaleRatio, height: geometry.size.width * scaleRatio)
                            .id(orientationManager.currentOrientation)
                    case .failed:
                        Image("maintenance-background")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.6)
                            .padding(.horizontal, 50)
                    }

                    Spacer()

                    VStack {
                        Text("Delegation proportions can be changed at any time")
                        Text("View Tx on \(txUrlHost)")
                            .underline()
                            .onTapGesture {
                                if let txUrl {
                                    openUrl(txUrl)
                                }
                            }
                    }
                    .foregroundStyle(Color.textWhite60)
                    .font(.footnoteRegular)
                    .padding(.bottom, 8)

                    PrimaryButton("Close") {
                        dismiss()
                    }
                }
                // this is needed as on iPad GeometryReader breaks VStack layout
                .frame(maxWidth: geometry.size.width, minHeight: geometry.size.height)
                .onAppear {
                    // TODO: track
                    model.monitor()
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}
