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
import CoinbaseWalletSDK

class SignInTwoStepsDataSource: ObservableObject {
    @Published private(set) var wcSessionMeta = WC_Manager.shared.sessionMeta
    @Published private(set) var cbWalletAccount = CoinbaseWalletManager.shared.account
    @Published private(set) var infoMessage: String?

    @Published private(set) var signInButtonEnabled = true
    @Published private(set) var recommendedDaos: [Dao]?

    private var cancellables = Set<AnyCancellable>()

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(wcSessionUpdated(_:)), name: .wcSessionUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cbWalletAccountUpdated(_:)), name: .cbWalletAccountUpdated, object: nil)
        listen_WC_Responses()
    }

    @objc private func wcSessionUpdated(_ notification: Notification) {
        DispatchQueue.main.async {
            if self.wcSessionMeta?.session.peer.name != WC_Manager.shared.sessionMeta?.session.peer.name {
                // Hide info message when a user changes wallet
                self.infoMessage = nil
            }
            self.wcSessionMeta = WC_Manager.shared.sessionMeta
            if self.wcSessionMeta != nil {
                self.cbWalletAccount = nil
            }
        }
    }

    @objc private func cbWalletAccountUpdated(_ notification: Notification) {
        DispatchQueue.main.async {
            self.cbWalletAccount = CoinbaseWalletManager.shared.account
            if self.cbWalletAccount != nil {
                self.wcSessionMeta = nil
            }
        }
    }

    private var wcAddress: String? {
        WC_Manager.shared.sessionMeta?.session.accounts.first?.address.lowercased()
    }

    private var cbAddress: String? {
        CoinbaseWalletManager.shared.account?.address.lowercased()
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
        guard let address = (wcAddress ?? cbAddress),
              let siweMessage = siweMessage else { return }

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
                                   message: siweMessage,
                                   signature: signature)
                .sink { response in
                    logInfo("[Auth] Response: \(response)")
                    // do nothing, error will be displayed to user
                } receiveValue: { [weak self] response, headers in
                    guard let `self` = self else { return }

                    let wcSessionMeta = self.wcSessionMeta
                    let cbAccount = self.cbWalletAccount

                    Task {
                        let profile = try! await UserProfile.upsert(profile: response.profile,
                                                                    deviceId: deviceId,
                                                                    sessionId: response.sessionId,
                                                                    wcSessionMeta: wcSessionMeta, 
                                                                    cbAccount: cbAccount)
                        try! await profile.select()

                        // Send Firebase token to backend for this profile
                        NotificationsManager.shared.enableNotificationsIfNeeded()
                    }
                    ProfileDataSource.shared.profile = response.profile
                    Tracker.track(.twoStepsSignedIn)
                    logInfo("[SIWE] Auth token: \(response.sessionId); Profile: \(address)")
                }
                .store(in: &cancellables)
        }
    }

    func authenticate() {
        infoMessage = nil

        if wcSessionMeta != nil {
            wcAuthenticate()
        } else if cbAddress != nil {
            cbAuthenticate()
        }
    }

    private func wcAuthenticate() {
        guard let session = WC_Manager.shared.sessionMeta?.session,
           let address = wcAddress else { return }
        formSiweMessage(address: address)
        let params = AnyCodable([siweMessage, address])

        let request = try! Request(
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

    private func cbAuthenticate() {
        guard let address = cbAddress else { return }
        formSiweMessage(address: address)

        CoinbaseWalletSDK.shared.makeRequest(
            Request(actions: [
                Action(
                    jsonRpc: .personal_sign(
                        address: address,
                        message: siweMessage!
                    )
                )
            ])
        ) { [weak self] result in
            switch result {
            case .success(let message):
                logInfo("[CoinbaseWallet] Authenticate response: \(message)")

                guard let result = message.content.first else {
                    logInfo("[CoinbaseWallet] Did not get any result for SIWE signing")
                    return
                }

                switch result {
                case .success(let signature_JSONString):
                    let signature = signature_JSONString.description.replacingOccurrences(of: "\"", with: "")
                    logInfo("[CoinbaseWallet] SIWE signature: \(signature)")
                    self?.signIn(signature: signature)
                case .failure(let actionError):
                    logInfo("[CoinbaseWallet] SIWE action error: \(actionError)")
                    showToast(actionError.message)
                }

            case .failure(let error):
                logInfo("[CoinbaseWallet] SIWE error: \(error)")
                CoinbaseWalletManager.disconnect()
                showToast("Please reconnect Coinbase Wallet")                
            }
        }
    }

    private func formSiweMessage(address: String) {
        let checksumAddress = Address(address).checksum!
        self.siweMessage = SIWE_Message.goverland(walletAddress: checksumAddress).message()
    }

    // MARK: - Recommended DAOs

    func getRecommendedDaos() {
        signInButtonEnabled = false

        APIService.profileDaoRecommendation()
            .sink { [weak self] completion in
                self?.signInButtonEnabled = true
                switch completion {
                case .finished: 
                    break
                case .failure(_):
                    // If request failed, we will not show DAO recommendations
                    logInfo("[App] Got failure")
                    self?.recommendedDaos = []
                }
            } receiveValue: { [weak self] daos, headers in
                logInfo("[App] Got \(daos.count) DAOs")
                self?.recommendedDaos = daos
            }
            .store(in: &cancellables)
    }
}
