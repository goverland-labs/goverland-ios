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

class WC_Manager {
    static let shared = WC_Manager()

    private let metadata = AppMetadata(
        name: "Goverland",
        description: "Mobile App for all DAOs",
        url: "https://goverland.xyz",
        // TODO: provide proper url
        icons: ["https://uploads-ssl.webflow.com/63f0e8f1e5b3e07d58817370/6480451361d81702d7d7ccae_goverland-logo-full.svg"]
    )

    private let sessionKey = "xyz.goverland.wc_session"

    var session: Session? {
        get {
            // TODO: take into account expire date - kill it if expired or about to expire
            if let encodedSession = UserDefaults.standard.data(forKey: sessionKey),
               let session = try? JSONDecoder().decode(Session.self, from: encodedSession) {
                return session
            }
            return nil
        }

        set {
            let encodedSession = try! JSONEncoder().encode(newValue)
            UserDefaults.standard.set(encodedSession, forKey: sessionKey)
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
            accentColor: .primary
        )
    }

    private func listen() {
        Sign.instance.sessionsPublisher
            .receive(on: DispatchQueue.main)
            .sink { session in
                logInfo("[WC] Sessions: \(session)")
            }
            .store(in: &cancelables)

        Sign.instance.sessionSettlePublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] session in
                logInfo("[WC] Session settle: \(session)")
                self.session = session
                NotificationCenter.default.post(name: .wcSessionUpdated, object: session)
            }
            .store(in: &cancelables)

        Sign.instance.sessionDeletePublisher
            .receive(on: DispatchQueue.main)
            .sink { (str, reason) in
                logInfo("[WC] Session deleted: String: \(str); Reason: \(reason)")
                self.session = nil
                NotificationCenter.default.post(name: .wcSessionUpdated, object: nil)
            }
            .store(in: &cancelables)        
    }
}
