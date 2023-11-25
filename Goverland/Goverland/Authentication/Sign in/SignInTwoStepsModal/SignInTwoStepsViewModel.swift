//
//  SignInTwoStepsViewModel.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 25.08.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation
import Combine
import UIKit
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

    var address: String? {
        WC_Manager.shared.sessionMeta?.session.accounts.first?.address
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
                    guard let signatureStr = signature.value as? String else {
                        logError(GError.appInconsistency(reason: "Expected signature as string. Got \(signature)"))
                        return
                    }
                    logInfo("[WC] Signature: \(signatureStr)")
                    self?.signIn(signature: signatureStr)
                }
            }
            .store(in: &cancellables)
    }

    private func signIn(signature: String) {
        guard let address = address else { return }
        APIService.regularAuth(address: address,
                               device: UIDevice.current.name,
                               message: siweMessage(address: address),
                               signature: signature)
            .sink { _ in
                // do nothing, error will be displayed to user
            } receiveValue: { response, _ in
                SettingKeys.shared.authToken = response.sessionId
                response.profile.cache()
                logInfo("Auth token: \(response.sessionId)")
                logInfo("Profile: \(response.profile)")
            }
            .store(in: &cancellables)
    }

    func authenticate() {
        guard let session = WC_Manager.shared.sessionMeta?.session,
            let address = address else { return }

        let dataStr = Data(siweMessage(address: address).utf8).toHexString()
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

    private func siweMessage(address: String) -> String {
        SIWE_Message.goverland(walletAddress: address).message()
    }
}
