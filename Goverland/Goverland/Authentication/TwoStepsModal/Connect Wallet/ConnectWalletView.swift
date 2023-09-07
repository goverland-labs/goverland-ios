//
//  ConnectWalletView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 30.08.23.
//

import SwiftUI
import WalletConnectModal


struct ConnectWalletView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var model = ConnectWalletModel()

    var body: some View {
        ZStack {
            VStack {
                List {
                    Section(header: Text("If connecting from other device")) {
                        QRRowView {
                            model.showQR()
                        }
                    }

                    Section {
                        WalletRowView(wallet: .rainbow, model: model)
                        WalletRowView(wallet: .oneInch, model: model)
                        WalletRowView(wallet: .uniswap, model: model)
                        WalletRowView(wallet: .zerion, model: model)
                    }

                    Section {
                        OtherWalletView()
                    }
                }
            }
            .padding(16)

            if model.qrDisplayed {
                WC_QRView(connectWalletModel: model)
                    .ignoresSafeArea(.all)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                }
            }
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Connect Wallet")
                        .font(.title3Semibold)
                        .foregroundColor(Color.textWhite)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .wcSessionUpdated)) { notification in
            guard notification.object != nil else { return }
            // session settled
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct Wallet {
    let image: String
    let name: String
    let link: URL

    static let zerion = Wallet(image: "zerion", name: "Zerion", link: URL(string: "https://wallet.zerion.io")!)
    static let rainbow = Wallet(image: "rainbow", name: "Rainbow", link: URL(string: "https://rnbwapp.com")!)
    static let oneInch = Wallet(image: "oneInch", name: "1Inch", link: URL(string: "https://wallet.1inch.io")!)
    static let uniswap = Wallet(image: "uniswap", name: "Uniswap", link: URL(string: "https://uniswap.org/app")!)
}

fileprivate struct QRRowView: View {
    let onTap: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "qrcode")
                .font(.system(size: 32))
            Text("Show QR code")
            Spacer()
        }
        .frame(height: 48)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

fileprivate struct OtherWalletView: View {
    var body: some View {
        HStack {
            Text("Other wallet")
            Spacer()
        }
        .frame(height: 48)
        .contentShape(Rectangle())
        .onTapGesture {
            logInfo("Other Wallet selected")
        }
    }
}

fileprivate struct WalletRowView: View {
    let wallet: Wallet
    let model: ConnectWalletModel

    var body: some View {
        HStack {
            Image(wallet.image)
                .frame(width: 32, height: 32)
                .scaledToFit()
                .cornerRadius(6)
            Text(wallet.name)
            Spacer()
            if model.connecting {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.textWhite60)
            }
        }
        .frame(height: 48)
        .contentShape(Rectangle())
        .onTapGesture {
            guard !model.connecting else { return }
            model.connect(wallet: wallet)
        }
    }
}

struct SelectWalletView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectWalletView()
    }
}
