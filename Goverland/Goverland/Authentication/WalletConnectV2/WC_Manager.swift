//
//  WC_Manager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 20.08.23.
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
        let session: Session
        let walletOnSameDevice: Bool
    }

    var sessionMeta: SessionMeta? {
        get {
            if let encodedSessionMeta = UserDefaults.standard.data(forKey: sessionMetaKey),
               let sessionMeta = try? JSONDecoder().decode(SessionMeta.self, from: encodedSessionMeta),
               // check session is valid and not finishing soon
               sessionMeta.session.expiryDate > .now + 30.minutes {
                return sessionMeta
            }
            return nil
        }

        set {
            let encodedSessionMeta = try! JSONEncoder().encode(newValue)
            UserDefaults.standard.set(encodedSessionMeta, forKey: sessionMetaKey)
        }
    }

    static func showModal() {
        WalletConnectModal.present()
    }

    private var cancelables = Set<AnyCancellable>()

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
            excludedWalletIds: Wallet.recommended.map { $0.id },
            accentColor: .primary,
            modalTopBackground: .containerBright
        )
    }

    /// Listed to events related to session. Session setteling hapens in ConnectWalletModel.
    private func listen() {
        Sign.instance.sessionsPublisher
            .receive(on: DispatchQueue.main)
            .sink { session in
                logInfo("[WC] Sessions: \(session)")
            }
            .store(in: &cancelables)

        Sign.instance.sessionDeletePublisher
            .receive(on: DispatchQueue.main)
            .sink { (str, reason) in
                logInfo("[WC] Session deleted: String: \(str); Reason: \(reason)")
                self.sessionMeta = nil
                NotificationCenter.default.post(name: .wcSessionUpdated, object: nil)
            }
            .store(in: &cancelables)
    }
}
