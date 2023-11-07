//
//  SignInTwoStepsViewModel.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 25.08.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation
import Combine
import WalletConnectSign

class SignInTwoStepsViewModel: ObservableObject {
    @Published var wcSessionMeta = WC_Manager.shared.sessionMeta

    private var cancellables = Set<AnyCancellable>()

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(wcSessionUpdated(_:)), name: .wcSessionUpdated, object: nil)
        listen_WC_Responses()
    }

    @objc private func wcSessionUpdated(_ notification: Notification) {
        wcSessionMeta = WC_Manager.shared.sessionMeta
    }

    private func listen_WC_Responses() {
        Sign.instance.sessionResponsePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                logInfo("[WC] Response: \(response)")
                switch response.result {
                case .error(let rpcError):
                    logInfo("[WC] Error: \(rpcError)")
                    showToast(rpcError.localizedDescription)                    
                case .response(let signature):
                    // signature here is AnyCodable
                    logInfo("[WC] Signature: \(signature)")
                    self?.signIn(signature: "\(signature)")
                }
            }
            .store(in: &cancellables)
    }

    private func signIn(signature: String) {
        APIService.regularAuth(signature: signature)
            .retry(3)
            .sink { _ in
                // do nothing, error will be displayed to user
            } receiveValue: { response, _ in
                SettingKeys.shared.authToken = response.sessionId
                logInfo("Auth token: \(response.sessionId)")
            }
            .store(in: &cancellables)
    }

    func authenticate() {
        guard let session = WC_Manager.shared.sessionMeta?.session,
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

        if let meta = wcSessionMeta, meta.walletOnSameDevice,
           let redirectUrlStr = meta.session.peer.redirect?.universal,
           let redirectUrl = URL(string: redirectUrlStr) {
            openUrl(redirectUrl)
        }
    }
}
