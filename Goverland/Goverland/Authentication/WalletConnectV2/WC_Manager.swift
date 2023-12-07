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

struct WC_SessionMeta: Codable {
    let session: WalletConnectSign.Session
    let walletOnSameDevice: Bool
}

class WC_Manager {
    static let shared = WC_Manager()

    private let metadata = AppMetadata(
        name: "Goverland",
        description: "Mobile App for all DAOs",
        url: "https://goverland.xyz",

        // TODO: provide proper url
        icons: ["https://uploads-ssl.webflow.com/63f0e8f1e5b3e07d58817370/6480451361d81702d7d7ccae_goverland-logo-full.svg"]
    )

    /// At any moment of time there can be only one WC session that the App works with.
    /// It is always the session of selected UserProfile.
    var sessionMeta: WC_SessionMeta? {
        didSet {
            NotificationCenter.default.post(name: .wcSessionUpdated, object: sessionMeta)
        }
    }

    static func showModal() {
        WalletConnectModal.present()
    }

    private var cancellables = Set<AnyCancellable>()

    private init() {
        configure()
        listen()
        getStoredSessionMeta()
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
            .sink { sessions in
                logInfo("[WC] Sessions count: \(sessions.count)")
            }
            .store(in: &cancellables)

        Sign.instance.sessionDeletePublisher
            .receive(on: DispatchQueue.main)
            .sink { topic, reason in
                logInfo("[WC] Session deleted: String: \(topic); Reason: \(reason)")
                Task {
                    try! await UserProfile.clear_WC_Sessions(topic: topic)
                }
            }
            .store(in: &cancellables)
    }

    private func getStoredSessionMeta() {
        Task {
            if let selectedProfile = try? await UserProfile.selected(), 
                let wcSessionMetaData = selectedProfile.wcSessionMetaData {
                self.sessionMeta = WC_SessionMeta.from(data: wcSessionMetaData)
            }
        }
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
