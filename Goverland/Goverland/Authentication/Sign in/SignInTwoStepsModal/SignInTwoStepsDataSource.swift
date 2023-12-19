//
//  SignInTwoStepsDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 25.08.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation
import Combine
import UIKit
import WalletConnectSign

class SignInTwoStepsDataSource: ObservableObject {
    @Published private(set) var wcSessionMeta = WC_Manager.shared.sessionMeta
    @Published private(set) var infoMessage: String?

    private var cancellables = Set<AnyCancellable>()

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(wcSessionUpdated(_:)), name: .wcSessionUpdated, object: nil)
        listen_WC_Responses()
    }

    @objc private func wcSessionUpdated(_ notification: Notification) {
        DispatchQueue.main.async {
            self.wcSessionMeta = WC_Manager.shared.sessionMeta
        }
    }

    private var address: String? {
        WC_Manager.shared.sessionMeta?.session.accounts.first?.address.lowercased()
    }

    private var siweMessage: String?

    private func listen_WC_Responses() {
        Sign.instance.sessionResponsePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                logInfo("[WC] Response: \(response)")
                switch response.result {
                case .error(let rpcError):
                    logInfo("[WC] Error: \(rpcError)")
                    showLocalNotification(title: "Rejected to sign", body: "Open the App to repeat the request")
                    showToast(rpcError.localizedDescription)
                case .response(let signature):
                    // signature here is AnyCodable
                    guard let signatureStr = signature.value as? String else {
                        logError(GError.appInconsistency(reason: "Expected signature as string. Got \(signature)"))
                        return
                    }
                    logInfo("[WC] Signature: \(signatureStr)")
                    showLocalNotification(title: "Signature response received", body: "Open the App to proceed")
                    self?.signIn(signature: signatureStr)
                }
            }
            .store(in: &cancellables)
    }

    private func signIn(signature: String) {
        guard let address = address else { return }
        let deviceName = UIDevice.current.name

        Task {
            // First, try to get a regular profile by address if it already exists (in case a user
            // tries to sign in with already signed in profile).
            //
            // If not, meaning we signing in with a
            // a) guest user
            // b) new user
            // then generate a new deviceId
            //
            // Different profiles should have different deviceIds for privacy considerations.
            let deviceId: String
            if let p = try! await UserProfile.getByAddress(address) {
                // regular user exists
                deviceId = p.deviceId
            } else {
                // new app user
                deviceId = UUID().uuidString
            }

            APIService.regularAuth(address: address,
                                   deviceId: deviceId,
                                   deviceName: deviceName,
                                   message: siweMessage!,
                                   signature: signature)
                .sink { _ in
                    // do nothing, error will be displayed to user
                } receiveValue: { [weak self] response, headers in
                    guard let `self` = self else { return }
                    let wcSessionMeta = self.wcSessionMeta
                    Task {
                        // TODO: rework when we have a multi-profile. Logout should not be called.
                        try! await UserProfile.signOutSelected()
                        let profile = try! await UserProfile.upsert(profile: response.profile,
                                                                    deviceId: deviceId,
                                                                    sessionId: response.sessionId, 
                                                                    wcSessionMeta: wcSessionMeta)
                        try! await profile.select()
                    }
                    ProfileDataSource.shared.profile = response.profile
                    logInfo("[SIWE] Auth token: \(response.sessionId); Profile: \(address)")
                }
                .store(in: &cancellables)
        }
    }

    func authenticate() {
        infoMessage = nil

        guard let session = WC_Manager.shared.sessionMeta?.session,
            let address = address else { return }

        formSiweMessage(address: address)

        let params = AnyCodable([siweMessage, address])

        let request = Request(
            topic: session.topic,
            method: "personal_sign",
            params: params,
            chainId: Blockchain("eip155:1")!)

        Task {
            try? await Sign.instance.request(params: request)

            if let redirectUrl = WC_Manager.sessionWalletRedirectUrl {
                openUrl(redirectUrl)
            } else {
                DispatchQueue.main.async {
                    self.infoMessage = "Please open your wallet to sign in"
                }
            }
        }
    }

    private func formSiweMessage(address: String) {
        let checksumAddress = Address(address).checksum!
        self.siweMessage = SIWE_Message.goverland(walletAddress: checksumAddress).message()
    }
}
