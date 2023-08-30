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

    var body: some View {
        VStack {
            List {
                Section(header: Text("If connecting from other device")) {
                    QRRowView()
                }

                Section {
                    WalletRowView(wallet: .rainbow)
                    WalletRowView(wallet: .oneInch)
                    WalletRowView(wallet: .uniswap)
                    WalletRowView(wallet: .zerion)
                }

                Section {
                    OtherWalletView()
                }
            }
        }
        .padding(16)
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
    }
}

struct Wallet {
    let image: String
    let name: String
    let link: URL

    static let zerion = Wallet(image: "zerion", name: "Zerion", link: URL(string: "https://wallet.zerion.io")!)
    static let rainbow = Wallet(image: "rainbow", name: "Rainbow", link: URL(string: "https://rnbwapp.com")!)
    static let oneInch = Wallet(image: "oneInch", name: "1Inch", link: URL(string: "https://wallet.1inch.io/")!)
    static let uniswap = Wallet(image: "uniswap", name: "Uniswap", link: URL(string: "https://uniswap.org/app")!)
}

fileprivate struct QRRowView: View {
    var body: some View {
        HStack {
            Image(systemName: "qrcode")
                .font(.system(size: 32))
            Text("Show QR code")
        }
        .frame(height: 48)
    }
}

fileprivate struct OtherWalletView: View {
    var body: some View {
        HStack {
            Text("Other wallet")
        }
        .frame(height: 48)
    }
}

fileprivate struct WalletRowView: View {
    let wallet: Wallet
    @StateObject private var model = WalletRowModel()

    var body: some View {
//        Button(action: {
//            guard !model.connecting else { return }
//            model.connect(wallet: wallet)
//        }) {
//            HStack {
//                Image(wallet.image)
//                    .frame(width: 32, height: 32)
//                    .scaledToFit()
//                    .cornerRadius(6)
//                Text(wallet.name)
//                Spacer()
//                if model.connecting {
//                    ProgressView()
//                        .progressViewStyle(.circular)
//                        .tint(.textWhite60)
//                }
//            }
//            .frame(height: 48)
//        }
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

fileprivate class WalletRowModel: ObservableObject {
    @Published private(set) var connecting = false

    func connect(wallet: Wallet) {
        connecting = true
        Task {
            do {
                let wcUri = try await WalletConnectModal.instance.connect(topic: nil)
                logInfo("[WC] URI: \(String(describing: wcUri))")                
            } catch {
                DispatchQueue.main.async {
                    ErrorViewModel.shared.setErrorMessage("Failed to connect. Please try again later.")
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(3)) {
            self.connecting = false
        }
    }
}

struct SelectWalletView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectWalletView()
    }
}
