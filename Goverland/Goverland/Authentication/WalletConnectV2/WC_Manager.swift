//
//  WC_Manager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 20.08.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation
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

        // TODO: provide proper url
        icons: ["https://uploads-ssl.webflow.com/63f0e8f1e5b3e07d58817370/6480451361d81702d7d7ccae_goverland-logo-full.svg"]
    )

    private let sessionMetaKey = "xyz.goverland.wc_session_meta"

    struct SessionMeta: Codable {
        let session: WalletConnectSign.Session
        let walletOnSameDevice: Bool
    }

    var sessionMeta: SessionMeta? {
        get {
            if let encodedSessionMeta = UserDefaults.standard.data(forKey: sessionMetaKey),
               let sessionMeta = try? JSONDecoder().decode(SessionMeta.self, from: encodedSessionMeta),
               // check session is valid and not finishing soon
               sessionMeta.session.expiryDate > .now + 5.minutes {
                logInfo("[WC] found stored session meta")
                return sessionMeta
            }
            logInfo("[WC] no stored session meta found")
            return nil
        }

        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: sessionMetaKey)
                return
            }
            let encodedSessionMeta = try! JSONEncoder().encode(newValue)
            UserDefaults.standard.set(encodedSessionMeta, forKey: sessionMetaKey)
        }
    }

    static func showModal() {
        WalletConnectModal.present()
    }

    private var cancellables = Set<AnyCancellable>()

    private init() {
        configure()
        listen()
    }

    private func configure() {
        Networking.configure(projectId: ConfigurationManager.wcProjectId, socketFactory: WC_SocketFactory.shared)

        // Pair.configure happens inside Modal
        WalletConnectModal.configure(
            projectId: ConfigurationManager.wcProjectId,
            metadata: metadata,
            sessionParams: SessionParams.goverland,
            excludedWalletIds: Wallet.recommended.map { $0.id },
            accentColor: .primaryDim,
            modalTopBackground: .containerBright
        )
    }

    /// Listed to events related to session. Session setteling hapens in ConnectWalletModel.
    private func listen() {
        Sign.instance.sessionsPublisher
            .receive(on: DispatchQueue.main)
            .sink { session in
                // TODO: beautify log
                //logInfo("[WC] Sessions: \(session)")
            }
            .store(in: &cancellables)

        Sign.instance.sessionDeletePublisher
            .receive(on: DispatchQueue.main)
            .sink { (str, reason) in
                logInfo("[WC] Session deleted: String: \(str); Reason: \(reason)")
                self.sessionMeta = nil
                NotificationCenter.default.post(name: .wcSessionUpdated, object: nil)
            }
            .store(in: &cancellables)
    }
}

extension SessionParams {
    static let goverland: Self = {
        let methods: Set<String> = ["eth_sendTransaction", "personal_sign", "eth_signTypedData", "eth_signTypedData_v4"]
        let events: Set<String> = ["chainChanged", "accountsChanged"]
        let blockchains: Set<Blockchain> = [Blockchain("eip155:1")!]
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
