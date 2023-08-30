//
//  TwoStepsViewModel.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 25.08.23.
//

import Foundation
import Combine
import WalletConnectSign

class TwoStepsViewModel: ObservableObject {
    @Published var wcSession = WC_Manager.shared.session
    // TODO: Add Loading State for button

    private var cancelables = Set<AnyCancellable>()

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(wcSessionUpdated(_:)), name: .wcSessionUpdated, object: nil)
        listen_WC_Responses()
    }

    @objc private func wcSessionUpdated(_ notification: Notification) {
        wcSession = WC_Manager.shared.session
    }

    private func listen_WC_Responses() {
        Sign.instance.sessionResponsePublisher
            .receive(on: DispatchQueue.main)
            .sink { response in
                logInfo("[WC] Response: \(response)")
                switch response.result {
                case .error(let rpcError):
                    logInfo("[WC] Error: \(rpcError)")
                    showError(rpcError.localizedDescription)                    
                case .response(let signature):
                    logInfo("[WC] Signature: \(signature)")
                }
            }
            .store(in: &cancelables)
    }

    func authenticate() {
        guard let session = WC_Manager.shared.session,
            let address = session.accounts.first?.address else { return }

        let dataStr = Data(SIWE_Message.goverland(walletAddress: address).message().utf8).toHexString()
        let params = AnyCodable([dataStr, address])

        let request = Request(
            topic: session.topic,
            method: "personal_sign",
            params: params,
            chainId: Blockchain("eip155:1")!)

        Task {
            try? await Sign.instance.request(params: request)
        }

//        if let walletUrl = URL(string: session.peer.url) {
//            logInfo("[WC] Wallet URL: \(walletUrl)")
//            UIApplication.shared.open(walletUrl)
//        }
    }
}
