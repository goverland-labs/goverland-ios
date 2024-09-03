//
//  WC_Manager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 20.08.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Combine
import WalletConnectNetworking
import WalletConnectModal
import UIKit
import SwiftDate

class WC_Manager {
    static let shared = WC_Manager()

    private let metadata = AppMetadata(
        name: "Goverland",
        description: "Mobile App for all DAOs",
        url: "https://goverland.xyz",
        icons: ["https://cdn.stamp.fyi/avatar/goverland.eth?s=180"],
        redirect: AppMetadata.Redirect(native: "goverland://", universal: "https://links.goverland.xyz")
    )

    /// At any moment of time there can be only one WC session that the App works with.
    /// It is always the session of selected UserProfile.
    var sessionMeta: WC_SessionMeta? {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .wcSessionUpdated, object: self.sessionMeta)
            }
            if sessionMeta != nil {
                CoinbaseWalletManager.shared.account = nil
            }
        }
    }

    var sessionExistsAndNotExpired: Bool {
        if let sessionMeta, !sessionMeta.isExpired {
            return true
        }
        logInfo("[WC] Session expiration date: \(WC_Manager.shared.sessionMeta?.session.expiryDate.toISO() ?? "NO SESSION")")
        return false
    }

    static func showModal() {
        WalletConnectModal.present()
    }

    static func disconnect(topic: String) {
        logInfo("[WC] App disconnecting from session with topic: \(topic)")
        Task {
            try? await WalletConnectModal.instance.disconnect(topic: topic)
            try! await UserProfile.clear_WC_Sessions(topic: topic)
            WC_Manager.shared.sessionMeta = nil
        }
    }

    static func extendSessionIfNeeded() {
        // Default expiry date is 7 days.
        // We will extend session at least after 15 min of the last session extension / creation
        guard let session = shared.sessionMeta?.session, session.expiryDate < .now + 7.days - 15.minutes else { return }
        logInfo("[WC] Extend session with topic: \(session.topic); address: \(session.accounts.first?.address ?? "unknown")")
        Task {
            try? await Sign.instance.extend(topic: session.topic)
        }
    }

    static var sessionWalletRedirectUrl: URL? {
        if let meta = WC_Manager.shared.sessionMeta, meta.walletOnSameDevice,
           let redirectUrlStr = meta.session.peer.redirect?.universal,
           let redirectUrl = URL(string: redirectUrlStr) {
            return redirectUrl
        }
        return nil
    }

    private var cancellables = Set<AnyCancellable>()

    private init() {
        getStoredSessionMeta()
        configure()
        listen()
    }

    private func configure() {
        // WalletConnect team enforced having group identifier. Not clear why.
        Networking.configure(
            groupIdentifier: "group.goverland",
            projectId: ConfigurationManager.wcProjectId,
            socketFactory: WC_SocketFactory.shared
        )

        // Pair.configure happens inside the Modal
        WalletConnectModal.configure(
            projectId: ConfigurationManager.wcProjectId,
            metadata: metadata,
            sessionParams: SessionParams.goverland,
            excludedWalletIds: Wallet.excluded.map { $0.id },
            accentColor: .primaryDim,
            modalTopBackground: .containerBright
        )

        // Otherwise it fails with error. Very strange enforcements from WC team.
        Sign.configure(crypto: MockCryptoProvider())
    }

    // Not needed. But WalletConnectModal will not configure without it.
    private struct MockCryptoProvider: CryptoProvider {
        func recoverPubKey(signature: EthereumSignature, message: Data) throws -> Data { Data() }
        func keccak256(_ data: Data) -> Data { Data() }
    }

    /// Listed to events related to session. Session setteling hapens in ConnectWalletModel.
    private func listen() {
        Sign.instance.sessionsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sessions in
                guard let self = self else { return }
                logInfo("[WC] Sessions count: \(sessions.count)")
                for s in sessions {
                    logInfo("[WC] Got session for: \(s.accounts.first?.address ?? "unknown"); Expire date: \(s.expiryDate)")
                    if let sessionMeta = self.sessionMeta, 
                        sessionMeta.session.topic == s.topic, sessionMeta.session.expiryDate < s.expiryDate {

                        // we update cached sessionMeta with new expiry date on getting update for this session
                        self.sessionMeta = .init(session: s, walletOnSameDevice: sessionMeta.walletOnSameDevice)

                        // and update it in the selected profile
                        Task {
                            try? await UserProfile.update_WC_SessionForSelectedProfile()
                        }
                        logInfo("[WC] Expiry date changed. Udated cached SessionMeta for: \(s.accounts.first?.address ?? "unknown"); walletOnSameDevice: \(sessionMeta.walletOnSameDevice)")
                    } else {
                        logInfo("[WC] No action needed.")
                    }
                }
            }
            .store(in: &cancellables)

        Sign.instance.sessionDeletePublisher
            .receive(on: DispatchQueue.main)
            .sink { topic, reason in
                logInfo("[WC] Session deleted by wallet: Topic: \(topic); Reason: \(reason)")
                Task {
                    try! await UserProfile.clear_WC_Sessions(topic: topic)
                }
            }
            .store(in: &cancellables)
    }

    private func getStoredSessionMeta() {
        Task {
            if let selectedProfile = try? await UserProfile.selected(),
                let wcSessionMetaData = selectedProfile.wcSessionMetaData
            {
                let sessionMeta = WC_SessionMeta.from(data: wcSessionMetaData)
                if sessionMeta?.isExpired ?? false {
                    // Disconnect from session. It will also clear session in selected profile.
                    logInfo("[WC] Stored cachned session is expired. Disconnecting.")
                    Self.disconnect(topic: sessionMeta!.session.topic)
                } else {
                    // All good. Set sessionMeta from stored data in selected profile
                    self.sessionMeta = sessionMeta
                    logInfo("[WC] Restored cachned SessionMeta from Profile. Address: \(sessionMeta!.session.accounts.first?.address ?? "unknown"); Expire date: \(sessionMeta!.session.expiryDate)")
                    // Extend it
                    Self.extendSessionIfNeeded()
                }
            }
        }
    }
}

extension SessionParams {
    static let goverland: Self = {
        let methods: Set<String> = ["eth_sendTransaction", "personal_sign", "eth_signTypedData", "eth_signTypedData_v4"]
        let events: Set<String> = ["chainChanged", "accountsChanged"]
        // TODO: we will need a smart logic. Issues with MetaMask, Rainbow (and probably many other wallets)
        let blockchains: Set<Blockchain> = [Blockchain("eip155:1")!/*, Blockchain("eip155:100")!*/]
        let namespaces: [String: ProposalNamespace] = [
            "eip155": ProposalNamespace(
                chains: blockchains,
                methods: methods,
                events: events
            )
        ]

        return SessionParams(
            requiredNamespaces: namespaces,
            optionalNamespaces: nil,
            sessionProperties: nil
        )
    }()
}
