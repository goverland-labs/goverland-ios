//
//  WC_QRView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 30.08.23.
//

import SwiftUI
import QRCode

fileprivate func viewHeight() -> CGFloat {
    if UIScreen.screenWidth < UIScreen.screenHeight {
        return UIScreen.screenWidth * 1.2
    } else {
        return UIScreen.screenHeight * 0.8
    }
}

struct WC_QRView: View {
    @Binding var showQR: Bool
    @StateObject private var model = QRViewModel()
    @StateObject private var orientationManager = DeviceOrientationManager()

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black.opacity(0.2))
                .onTapGesture {
                    showQR = false
                }

            VStack {
                Spacer()

                Rectangle()
                    .id(orientationManager.currentOrientation)
                    .foregroundColor(.containerBright)
                    .frame(maxWidth: .infinity, maxHeight: viewHeight())
                    .mask(TopRoundedCornerShape(radius: 40))
                    .overlay(
                        VStack {
                            HStack {
                                Spacer()
                                Button {
                                    showQR = false
                                } label: {
                                    // TODO: Fix in other places
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.textWhite40)
                                        .font(.system(size: 26))
                                }
                            }
                            .padding(16)

                            Text("Scan with your Wallet")
                                .font(.headlineSemibold)
                                .foregroundColor(.textWhite)

                            QRView(content: "let height = min(UIScreen.main.bounds.width - 16, UIScreen.main.bounds.height * 0.4)")

                            Text("\u{20F0} Wallet should support WalletConnect")
                                .font(.footnoteRegular)
                                .foregroundColor(.textWhite60)

                            Spacer()
                        }
                    )
            }
        }
    }



    // Based on WalletConnect fork of dagronf/QRCode
    // https://github.com/WalletConnect/QRCode
    struct QRView: View {
        let content: String

        var edge: CGFloat {
            if UIScreen.screenWidth < UIScreen.screenHeight {
                return UIScreen.screenWidth * 0.75
            } else {
                return viewHeight() * 0.5
            }
        }

        var body: some View {
            qrImage(content: content, size: CGSize(width: edge, height: edge))
        }

        func qrImage(content: String, size: CGSize) -> Image {
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
}

fileprivate class QRViewModel: ObservableObject {
    @Published private(set) var loading = false
}

struct WC_QRView_Previews: PreviewProvider {
    static var previews: some View {
        WC_QRView(showQR: .constant(true))
    }
}
