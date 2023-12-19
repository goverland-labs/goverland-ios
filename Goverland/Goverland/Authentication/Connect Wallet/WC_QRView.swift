//
//  WC_QRView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 30.08.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import QRCode
import WalletConnectModal

struct WC_QRView: View {
    let connectWalletModel: ConnectWalletModel

    @StateObject private var model = QRViewModel()
    @StateObject private var orientationManager = DeviceOrientationManager.shared

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black.opacity(0.2))
                .onTapGesture {
                    connectWalletModel.hideQR()
                }

            VStack {
                Spacer()

                Rectangle()
                    .id(orientationManager.currentOrientation)
                    .foregroundColor(.containerBright)
                    .frame(maxWidth: .infinity, maxHeight: viewHeight)
                    .mask(TopRoundedCornerShape(radius: 40))
                    .overlay(
                        VStack {
                            HStack {
                                Spacer()
                                Button {
                                    connectWalletModel.hideQR()
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.textWhite40)
                                        .font(.system(size: 26))
                                }
                            }
                            .padding(16)

                            Text("Scan with your Wallet \u{20F0}")
                                .font(.headlineSemibold)
                                .foregroundColor(.textWhite)

                            if let uri = model.uri {
                                QRView(content: uri, edge: qrEdge)
                            } else {
                                QRView.LoadingView(edge: qrEdge)
                            }

                            Text("\u{20F0} Wallet should support WalletConnect")
                                .font(.footnoteRegular)
                                .foregroundColor(.textWhite60)

                            Spacer()
                        }
                    )
            }
        }
        .onAppear {
            model.loadURI()
        }
        .onReceive(model.$failedToLoad) { failed in
            if failed {
                connectWalletModel.hideQR()
            }
        }
    }

    // Based on WalletConnect fork of dagronf/QRCode
    // https://github.com/WalletConnect/QRCode
    struct QRView: View {
        let content: String
        let edge: CGFloat

        struct LoadingView: View {
            let edge: CGFloat

            var body: some View {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.textWhite20)
                    .frame(width: edge, height: edge)
            }
        }

        var body: some View {
            qrImage(content: content, size: CGSize(width: edge, height: edge))
        }

        private func qrImage(content: String, size: CGSize) -> Image {
            let doc = QRCode.Document(utf8String: content, errorCorrection: .quantize)
            doc.design.shape.eye = QRCode.EyeShape.Squircle()
            doc.design.shape.onPixels = QRCode.PixelShape.Vertical(
                insetFraction: 0.2,
                cornerRadiusFraction: 1
            )

            doc.design.style.eye = QRCode.FillStyle.Solid(UIColor(named: "Primary Dim")!.cgColor)
            doc.design.style.pupil = QRCode.FillStyle.Solid(UIColor(named: "Primary Dim")!.cgColor)
            doc.design.style.onPixels = QRCode.FillStyle.Solid(UIColor(named: "Primary Dim")!.cgColor)
            doc.design.style.background = QRCode.FillStyle.Solid(UIColor(named: "Container Bright")!.cgColor)

            doc.logoTemplate = QRCode.LogoTemplate(
                image: UIImage(named: "goverland-logo-round")!.cgImage!,
                path: CGPath(
                    rect: CGRect(x: 0.33, y: 0.33, width: 0.34, height: 0.34),
                    transform: nil
                )
            )

            return doc.imageUI(
                size, label: Text("QR code with WalletConnect URI")
            )!
        }
    }

    var viewHeight: CGFloat {
        if UIScreen.screenWidth < UIScreen.screenHeight {
            return UIScreen.screenWidth * 1.1
        } else {
            return UIScreen.screenHeight * 0.8
        }
    }

    var qrEdge: CGFloat {
        if UIScreen.screenWidth < UIScreen.screenHeight {
            return UIScreen.screenWidth * 0.6
        } else {
            return viewHeight * 0.5
        }
    }
}

fileprivate class QRViewModel: ObservableObject {
    @Published private(set) var failedToLoad = false
    @Published private(set) var uri: String?

    func loadURI() {
        failedToLoad = false
        uri = nil
        Task {
            do {
                guard let wcUri = try await WalletConnectModal.instance.connect(topic: nil) else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.uri = wcUri.absoluteString
                }
                logInfo("[WC] URI: \(uri?.description ?? "None")")
            } catch {
                showToast("Failed to connect. Please try again later.")
                DispatchQueue.main.async { [weak self] in
                    self?.failedToLoad = true
                }
            }
        }
    }
}
